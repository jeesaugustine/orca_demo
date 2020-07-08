import numpy as np
import igraph
import time
import pickle
from the_traffic_magic import get_pareto_traffic_one
from helper_scratch import igraph_get_top_routing_nodes, \
    igraph_connect_all_top_nodes_criss_cross, go_write_partial_a_and_b, \
    go_write_full_a_and_b
import os


def write_A_matrix(graph_file_name, A_matrix_file_name, b_vector_file_name, gravity_vector_file_name):
    # G = igraph.Graph.Read(graph_file_name, format="edgelist", directed=False)
    G = igraph.Graph.Erdos_Renyi(n=100, m=70, directed=False)
    pick_level_one_routers = 100
    pick_level_one_routers = 3
    print('Done Reading')

    to_delete_ids = [v.index for v in G.vs if v.degree() == 0]
    G.delete_vertices(to_delete_ids)

    nodes = G.vs.indices
    now = time.time()

    # Connect the unconnected components
    unconnected = list(G.clusters())
    for one, two in zip(unconnected[:-1], unconnected[1:]):
        G.add_edges([(one[0], two[0])])

    top_nodes = igraph_get_top_routing_nodes(G, pick_level_one_routers)
    routing_nodes = [node for (node, val) in top_nodes]
    print('Total time for making routing nodes - ', time.time() - now, ' total routing nodes - ', len(routing_nodes))

    now = time.time()
    igraph_connect_all_top_nodes_criss_cross(G, routing_nodes)
    print('Criss Cross connecting time - ', time.time() - now)

    assert len(list(G.clusters())) == 1
    clusters = {node: {} for node in routing_nodes}
    for each in routing_nodes:
        nodes.remove(each)

    non_routing_nodes = nodes
    path_collector = {}
    for each_routing_node in routing_nodes:
        path_collector[each_routing_node] = G.get_shortest_paths(each_routing_node, mode=igraph.OUT,output='vpath')
    print('cluster eye shortest paths done')

    # code below shows the cluster assignments
    # each node is assigned to the nearest cluster according to path length
    G.vs['which_cluster'] = ""
    now = time.time()
    with open('igraph.pickle', 'wb') as handle:
        pickle.dump(G, handle)
    for non_routing_node in non_routing_nodes:
        path_length = 10000000000
        cluster = None
        for routing_node in path_collector:
            if len(path_collector[routing_node][non_routing_node]) < path_length:
                path_length = len(path_collector[routing_node][non_routing_node])
                cluster = routing_node
        clusters[cluster][non_routing_node] = path_collector[cluster][non_routing_node]
        # if cluster == []:
        #     print('Whose cluster are you  ?')
        G.vs[non_routing_node]['which_cluster'] = cluster
        # reverse_map[non_routing_node] = cluster
    print('cluster assignment took: ', time.time() - now)

    with open('edges.txt', 'w') as f:
        for each in G.es:
            f.write(str(each.source) + ', ' + str(each.target) + '\n' )

    s_d_pair_index = 0
    #Read uses a 0 based index - so if using 1 based index be careful about indices
    start_node = 0 #in case you want to do a dumb parallelization set these values
    end_node = G.vcount() #ditto

    # create a fake attribute to store all sd_paths this edge participates in.
    # Igraph does not allow empty sequences - so put a sentinel and remove it later
    G.es["sd_pairs"] = ""
    G.es["edge_traffic"] = "0"

    write_head = 500000
    write_head = 50000
    write_head_adder = 500000
    write_head_adder = 50000

    # write_head = 500
    dir_path = os.getcwd()
    dir_path = os.path.join(dir_path, 'data')

    output_file_gravity = open(gravity_vector_file_name, "w")
    gravity = []
    original_traffic = []
    actual = open(os.path.join(dir_path, "actual.csv"), "w")
    import random
    random.shuffle(non_routing_nodes)
    for n_1 in non_routing_nodes:
        # print(s_d_pair_index)
        if s_d_pair_index > 1000000000:
        # if s_d_pair_index > 1000:
            break
        for n_2 in non_routing_nodes:
            if s_d_pair_index > 1000000000:
            # if s_d_pair_index > 1000:
                break
            if not n_1 == n_2:
                s_d_pair_index_as_str = str(s_d_pair_index)
                if not G.vs[n_1]['which_cluster'] == G.vs[n_2]['which_cluster']:
                    path_1 = clusters[G.vs[n_1]['which_cluster']][n_1][::-1]
                    path_2 = clusters[G.vs[n_2]['which_cluster']][n_2]
                    path = path_1 + path_2
                else:
                    path_1 = clusters[G.vs[n_1]['which_cluster']][n_1][::-1]
                    path_2 = clusters[G.vs[n_2]['which_cluster']][n_2][1:]
                    path = path_1 + path_2
                if path_1 == [] or path_2 == []:
                    print('Where are you lost')
                traffic = get_pareto_traffic_one(1, 20)
                for (edge_src, edge_target) in zip(path[:-1], path[1:]):
                    G.es[G.get_eid(edge_src, edge_target)]["sd_pairs"] += s_d_pair_index_as_str + ","
                    G.es[G.get_eid(edge_src, edge_target)]["edge_traffic"] = str(
                        int(G.es[G.get_eid(edge_src, edge_target)]["edge_traffic"]) + traffic)
                gravity.append(s_d_pair_index_as_str + '\t' + str(0.02*traffic*abs(np.random.normal())))
                original_traffic.append(s_d_pair_index_as_str + '\t' + str(traffic))
                s_d_pair_index += 1
        output_file_gravity.write('\n'.join(gravity) + '\n')
        actual.write('\n'.join(original_traffic) + '\n')
        gravity = []
        original_traffic = []
        # if s_d_pair_index > write_head:
            # write_head = go_write_partial_a_and_b(G, write_head, s_d_pair_index, 'partial_results', 50000000)
            # write_head = go_write_partial_a_and_b(G, write_head, s_d_pair_index, 'partial_results', write_head_adder)
    if len(gravity) > 0:
        output_file_gravity.write('\n'.join(gravity))
    if len(original_traffic) > 0:
        actual.write('\n'.join(gravity))

    output_file_gravity.close()
    actual.close()

    print('Gravity Calculation - Done')

    # write_head = go_write_partial_a_and_b(G, write_head, s_d_pair_index, 'partial_results', write_head_adder)
    go_write_full_a_and_b(G, s_d_pair_index)
    # output_file = open(A_matrix_file_name, "w")
    # output_file.write(str(G.ecount()) + "," + str(s_d_pair_index - 1) + "\n")
    # b_file = open(b_vector_file_name, "w")
    #
    # for edge in G.es:
    #     output_file.write(edge["sd_pairs"][:-1] + "\n")
    #     b_file.write(edge["edge_traffic"] + "\n")
    # output_file.close()
    # b_file.close()

# write_A_matrix("test_graph.txt", "a.csv", 'b.csv', 'gravity.csv')
# write_A_matrix("p2p-Gnutella04_Nodes_10876_edges_39994.txt", "a_gnutella_.csv", 'b_gnutella.csv','gravity_gnutella.csv')
# write_A_matrix("Wiki-Vote_100_edge.txt", "100ke_a_wiki_vote.csv", '100ke_b_gnutella.csv','100ke_gravity_wiki_vote.csv')

dir_path = os.getcwd()
dir_path = os.path.join(dir_path, 'data')
write_A_matrix("", os.path.join(dir_path, "a.csv"), os.path.join(dir_path,'b.csv'),os.path.join(dir_path, 'g.csv'))
# write_A_matrix("email_25k.txt", "25ke_a_email.csv", '25ke_b_email.csv','25ke_gravity_email.csv')
# write_A_matrix("p2p-Gnutella08.txt", "25ke_a_gnutella_.csv", '25ke_b_gnutella.csv','25ke_gravity_gnutella.csv')
# write_A_matrix("Brightkite_edges.txt", "200ke_a_brightkite_.csv", '200ke_b_brightkite.csv','200ke_brightkite.csv')

# write_A_matrix("web_Google_Nodes_875713_Edges_5105039.txt", "a_google.csv", 'b_google.csv','gravity_google.csv')

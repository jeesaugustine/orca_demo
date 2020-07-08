import os 
import numpy as np

class AMaker:
	def __init__(self, dim,a, dp):
		self.edge = int(dim[0])
		self.sd = int(dim[1])
		self.a_compressed = a
		self.full_a = []
		self.att = None
		self.attThresh = None
		self.attThreshCompliment = None
		self.data_path = dp
		self.threshold = 1

	def uncompress(self):
		for edge in self.a_compressed:
			row = [0]*self.sd
			if len(edge.strip()) != 0:
				for e in edge.strip().split(','):
					# print(e)
					row[int(e)] = 1
			self.full_a.append(row)
		self.full_a = np.array(self.full_a)

	def get_full_a(self):
		if len(self.full_a) == 0:
			self.uncompress()

	def aat(self):
		self.get_full_a()
		self.att = np.dot(self.full_a,self.full_a.T)

	def save_file(self):
		if self.att is None:
			self.aat()
		np.savetxt(os.path.join(self.data_path, "aat.csv"), self.att, fmt="%d",delimiter=",")

	def aat_th(self, th):
		self.threshold = th
		self.attThresh = np.copy(self.att)
		self.attThreshCompliment =np.ones((self.edge, self.edge), dtype = np.int8)
		for i in range(0, self.edge):
			if self.att[i,i] < self.threshold:
				self.attThresh[i,:] = 0
				self.attThresh[:,i] = 0
				self.attThreshCompliment[i,:] = 0
				self.attThreshCompliment[:,i] = 0
				self.attThreshCompliment[i,i] = 1
				self.attThresh[i,i] = self.att[i, i]
		np.savetxt(os.path.join(self.data_path, "aatThresh.csv"), self.attThresh, fmt="%d",delimiter=",")
		np.savetxt(os.path.join(self.data_path, "aatThreshCompliment.csv"), self.attThreshCompliment, fmt="%d",delimiter=",")


def get_path():
	
	path = os.getcwd()
	data_path = os.path.join(path, "data")
	return path, data_path
	
if __name__ == "__main__":
	path, data_path = get_path()
	a = None
	with open(os.path.join(data_path, "a.txt"), "rb") as f:
		a = f.readlines()
	# print(type(a), a[0])
	amaker = AMaker(a[0].strip().split(','), a[1:], data_path)
	amaker.save_file()
	print(int(amaker.sd/10))
	amaker.aat_th(int(amaker.sd/10))

# from flask import Flask
from flask import Flask, request, render_template
import subprocess
import time
import os
import dash
import dash_html_components as html
import dash_core_components as dcc
from dash.dependencies import Input, Output

# app = Flask(__name__)

app = dash.Dash('Dash Hello World')

text_style = dict(color='#444', fontFamily='sans-serif', fontWeight=300)
plotly_figure = dict(data=[dict(x=[1,2,3], y=[2,4,8])])

app.layout = html.Div([ 
        html.H2('My First Dash App', style=text_style),
        html.P('Enter a Plotly trace type into the text box, such as histogram, bar, or scatter.', style=text_style),
        dcc.Input(id='text1', placeholder='box', value=''),
        dcc.Dropdown(
        id='my-dropdown',
        options=[
            {'label': 'New York City', 'value': 'NYC'},
            {'label': 'Montreal', 'value': 'MTL'},
            {'label': 'San Francisco', 'value': 'SF'}
        ],
        value='NYC'
    ),
        dcc.Graph(id='plot1', figure=plotly_figure),
    ])

@app.callback(Output('plot1', 'figure'), [Input('text1', 'value')] )
def text_callback( text_input ):
    return {'data': [dict(x=[1,2,3], y=[2,4,8], type=text_input)]}

# @app.route('/')
# def my_form():
#     return render_template('my-form.html')

# @app.route('/', methods=['POST'])
# def my_form_post():
# 	if request.method == 'POST':
# 		print("Jees")
		
# 		tyGraph = request.form["tyGraph"]
# 		tyTraffic = request.form["tyTraffic"]
# 		tyPrior = request.form["tyPrior"]
# 		print(tyGraph, tyTraffic, tyPrior)
# 		# time.sleep(15)
# 	name = os.path.join("SR", "main.cpp")
# 	# name = '/SR/main.cpp'
# 	path = os.getcwd()
# 	print(os.path.join(path, name))

# 	file_path = os.path.join(os.path.join(os.path.join(path,  'data'), "200ke"), "8M")
# 	print(file_path)
# 	subprocess.call(["g++",os.path.join(path, name+'/')])
# 	tmp=subprocess.call(["./a.out", "-f", file_path, "-o", os.path.join(path, "output.txt")])


#     # text = request.form['text']
#     # processed_text = text.upper()
#     # return processed_text

# def hello_world():
#   return 'Hello, World!\n This looks just amazing within 5 minutes'

if __name__ == '__main__':
  # app.run()
  app.server.run()

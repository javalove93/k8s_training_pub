# Flask Hello World

from flask import Flask
from flask import request

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Flask Hello World'

# a = 0
# b = 1 / a

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8081)


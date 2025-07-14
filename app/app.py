from flask import Flask
import requests

app = Flask(__name__)

@app.route("/health")
def health():
    return "The app is healthy", 200

@app.route("/hello")
def hello():
    return "Hello there!"

@app.route("/error")
def intentional_error():
    return "An intentional server error occurred", 500

@app.route("/check-external")
def check_external():
    teapotUrl = "https://httpbin.org/status/418"
    resp = requests.get(teapotUrl)
    return f"Got {resp.status_code}"

# Flask will automatically use the value from the FLASK_RUN_PORT env var,
# or default to 5000 if it's not set
if __name__ == "__main__":
    app.run(host="0.0.0.0")

import time
import random
import requests
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/health")
def health():
    return "The app is healthy", 200

# @app.route("/hello")
# def hello():
#     return "Hello there!"
#
# @app.route("/error")
# def intentional_error():
#     return "An intentional server error occurred", 500
#
# @app.route("/check-external")
# def check_external():
#     teapotUrl = "https://httpbin.org/status/418"
#     resp = requests.get(teapotUrl)
#     return f"Got {resp.status_code}"

@app.route("/checkout")
def checkout():
    try:
        # Simulate some internal logic
        time.sleep(random.uniform(0.05, 0.15))

        # Call the "payment" microservice (hosted in same Flask app)
        url = "http://flask-app.flask-app-ns.svc.cluster.local:5000/payment"
        # url = "http://flask-app:5000/payment" # OK: if flask-simulator that hits the EP is in the same namespace

        resp = requests.get(url, timeout=2)

        return jsonify({
            "message": "Checkout successful",
            "payment_status": resp.json()
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/payment")
def payment():
    # Simulate latency or failure
    delay = random.choice([0.1, 0.2, 0.3, 1.5])  # sometimes slow
    time.sleep(delay)

    if delay > 1.0:
        return jsonify({"error": "Payment API timeout"}), 500
    return jsonify({"status": "payment processed"}), 200


# Flask will automatically use the value from the FLASK_RUN_PORT env var,
# or default to 5000 if it's not set
if __name__ == "__main__":
    app.run(host="0.0.0.0")

from flask import Flask

app = Flask(__name__)


@app.get('/')
def home():
    return "Smart Auto-Deployment System ✅\n"


@app.get('/health')
def health():
    return {"status": "ok"}


if __name__ == '__main__':
    # Docker will pass PORT via environment if you want
    import os

    port = int(os.environ.get('PORT', 5000))
    # Binding 0.0.0.0 is required inside containers
    app.run(host='0.0.0.0', port=port, debug=False)


import runpod

def handler(job):
    return {
        "status": "ok"
    }

if __name__ == "__main__":
    runpod.serverless.start({"handler": handler})

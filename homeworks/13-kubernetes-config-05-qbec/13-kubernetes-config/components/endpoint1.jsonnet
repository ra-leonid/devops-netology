[
  {
    "apiVersion": "v1",
    "kind": "Endpoints",
    "metadata": {
      "name": "endpoint1"
    },
      "subsets": [
        {
          "addresses": [

            {
                "ip": "84.201.15.60"
            }

          ],
          "ports": [
                {
                    "name": "web",
                    "port": 443,
                },
            ],
        }
      ]
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "endpoint1",
      "labels": {
         "name": "endpoint1"
      }
    },
    "spec": {
    "selector": {
        "name": "endpoint1"
      },
      "ports": [
        {
          "name": "web",
          "protocol": "TCP",
          "port": 443,
          "targetPort": 443
        }
      ]
    }
  },
]
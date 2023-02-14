
local p = import '../params.libsonnet';
local params = p.components.backend;

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: params.name,
      labels: {
        app: params.name,
      },
    },
    spec: {
      replicas: params.replicas,
      selector: {
        matchLabels: {
          app: params.name,
        },
      },
      template: {
        metadata: {
          labels: {
            app: params.name,
          },
        },
        spec: {
          containers: [
            {
              name: params.name,
              image: params.image.repository + ':' + params.image.tag,
              ports: [
                {
                  name: 'http',
                  containerPort: params.service.port,
                  protocol: 'TCP',
                }
              ],
              env: [
                {
                  name: 'DATABASE_URL',
                  value: 'postgres://postgres:postgres@' + p.components.db.name + ':' + p.components.db.service.port + '/news',
                }
              ],
              imagePullPolicy: params.image.pullPolicy,
            },
          ],
        },
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: params.name,
    },
    spec: {
      ports: [
        {
          name: params.name,
          port: params.service.port,
        }
      ],
      selector: {
        app: params.name,
      },
      type: params.service.type,
    }
  }
]


local p = import '../params.libsonnet';
local params = p.components.db;

[
  {
    apiVersion: 'v1',
    kind: 'PersistentVolume',
    metadata: {
      name: 'pv-10mi-nfc-' + p.nameSpace,
      labels: {
        app: params.name,
      },
    },
    spec: {
      storageClassName: 'nfs',
      accessModes: ['ReadWriteOnce'],
      capacity: {
        storage: '100Mi'
      },
      hostPath: {
        path: '/data/pv'
      },
      persistentVolumeReclaimPolicy: 'Delete',
    },
  },
  {
    apiVersion: 'v1',
    kind: 'PersistentVolumeClaim',
    metadata: {
      name: 'my-pvc',
      labels: {
        app: params.name,
      },
    },
    spec: {
      storageClassName: 'nfs',
      accessModes: ['ReadWriteOnce'],
      resources: {
        requests: {
          storage: '100Mi'
        }
      },
    },
  },
  {
    apiVersion: 'apps/v1',
    kind: 'StatefulSet',
    metadata: {
      name: params.name,
      labels: {
        app: params.name,
      },
    },
    spec: {
      serviceName: params.name,
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
                  name: 'POSTGRES_USER',
                  value: 'postgres',
                },
                {
                  name: 'POSTGRES_PASSWORD',
                  value: 'postgres',
                },
                {
                  name: 'POSTGRES_DB',
                  value: 'news',
                },
              ],
              imagePullPolicy: params.image.pullPolicy,
              volumeMounts: [
                {
                  name: 'pgdata',
                  mountPath: '/var/lib/postgresql/data',
                },
              ],
            },
          ],
          volumes: [
            {
              name: 'pgdata',
              persistentVolumeClaim: {
                claimName: 'my-pvc'
              },
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

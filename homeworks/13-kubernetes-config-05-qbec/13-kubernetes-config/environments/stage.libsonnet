local component(name, port, repository, tag, replicas=1) = {
  name: name,
  [if replicas != null then 'replicas']: replicas,
  image: {
    repository: repository,
    tag: tag,
    pullPolicy: 'IfNotPresent',
  },
  service: {
    type: 'ClusterIP',
    port: port,
  }
};

{
  components: {
    local fr = component('frontend', 8000, 'raleonid/frontend', '0.1.0'),
    // Дополнить во frontend.service
    frontend: fr + (
      {
        service +: {
          targetPort: 80,
        }
      }
    ),
    backend: component('backend', 9000, 'raleonid/backend', '0.1.0'),
    db: component('db', 5432, 'postgres', '13-alpine', null),
  },
}

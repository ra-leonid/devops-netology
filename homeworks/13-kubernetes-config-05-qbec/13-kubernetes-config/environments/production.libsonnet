
// this file has the param overrides for the default environment
local base = import './stage.libsonnet';
local replicas = 3;

base {
  components +: {
    frontend +: {
      replicas: replicas,
    },
    backend +: {
      replicas: replicas,
    },
  }
}

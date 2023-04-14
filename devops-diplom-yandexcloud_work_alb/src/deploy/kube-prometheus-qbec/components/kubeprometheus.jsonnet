local env = {
  name: std.extVar('qbec.io/env'),
  namespace: std.extVar('qbec.io/defaultNs'),
};
local p = import '../params.libsonnet';
local params = p.components.kubeprometheus;

std.native('expandHelmTemplate')(
  '../vendor/kube-prometheus-stack',
  {},
  //params.values,
  {
    nameTemplate: params.name,
    //name: params.name,
    namespace: env.namespace,
    thisFile: std.thisFile,
    verbose: true,
  }
)

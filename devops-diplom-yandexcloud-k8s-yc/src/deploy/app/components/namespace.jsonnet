local env = {
  name: std.extVar('qbec.io/env'),
  namespace: std.extVar('qbec.io/defaultNs'),
};


{
  "apiVersion": "v1",
  "kind": "Namespace",
  "metadata": {
      "name": env.namespace
  }
}

// this file has the param overrides for the default environment
local base = import './base.libsonnet';

base {
  components +: {
    app_meow +: {
      service +: {
				local svc = super.ports[0],
				type: 'NodePort',
				port +: {
					nodePort: 30081
				}
      },
    },
  }
}

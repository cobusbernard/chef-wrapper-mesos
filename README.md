# chef-wrapper-mesos-cookbook

Wrapper cookbook to install Mesos in a cluster.

## Supported Platforms

Ubuntu 14.04

## Usage

### chef-wrapper-mesos::default

Include `chef-wrapper-mesos` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[chef-wrapper-mesos::default]"
  ]
}
```

## License and Authors

Author:: Cobus Bernard (<me@cobus.io>)

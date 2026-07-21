# chef-install

[![CI State](https://github.com/actionshub/chef-install/workflows/release/badge.svg)](https://github.com/actionshub/chef-delivery)

A Github Action to install Chef on a build agent

Note you will need to accept the Chef license, you can find more information at <https://docs.chef.io/chef_license.html>

## Usage

```yaml
name: delivery

on: [push, pull_request]

jobs:
  delivery:

    runs-on: ubuntu-latest

    steps:
    - name: Check out code
      uses: actions/checkout@master
    - name: install chef
      uses: actionshub/chef-installl@master
 ```

## Envrionment Variables

We support the following Environment Variables

|name| default| description|
|--- |------- |----------- |
|channel| stable | Chef Channel to install, stable or current |
|project | chef-workstation | Which product to install, see <https://docs.chef.io/install_omnibus.html> for the list |
|version | latest | version to install |
|omnitruckUrl| omnitruck.chef.io | which Omnitruck to use, default is Chef Official|

By Changing the omnitruck Url you can also install Cinc projects

## Privacy

This Action contacts Chainguard's licensing server to verify authorization. Connection metadata (IP address, GitHub repository identifier, timestamp, and any metadata encoded in the auth token) is transmitted to Chainguard, Inc. even if authorization is denied in accordance with our [Privacy Notice](https://www.chainguard.dev/legal/privacy-notice)

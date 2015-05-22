# Apollo deploy
[![wercker status](https://app.wercker.com/status/6964428ac035f8850dbd4d359decc25a/s "wercker status")](https://app.wercker.com/project/bykey/6964428ac035f8850dbd4d359decc25a)

A step for deploying Apollo and run serverspecs.

## Dependencies

This build-step depends on ansible, wget and unzip being installed, if any it's missing, the buildstep wil fail. Please install those in your box wercker.yml

You can do this as follows -

```yaml
build:
  steps:
    - install-packages:
        packages: wget unzip
    - pip-install:
        requirements_file: ""
        packages_list: "ansible"
```

## Usage

```yaml

deploy:
  steps:
    - capgemini/apollo-deploy:
        cloud: digitalocean
        artifact_name: username/apollo-ubuntu-14.04-amd64
        artifact_version: 1
        terraform_version: 0.5.0
        run_tests: true
```

## License

The MIT License (MIT)

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fixtures,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  rich,
  setuptools,
  tomli,
  urllib3,
}:

buildPythonPackage rec {
  pname = "podman";
  version = "5.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-py";
    tag = "v${version}";
    hash = "sha256-c8uU5WZsZufi/QNJkXh2Z1bmoM/oOm6+rggm4J+pnIc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    urllib3
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  optional-dependencies = {
    progress_bar = [ rich ];
  };

  nativeCheckInputs = [
    fixtures
    pytestCheckHook
    requests-mock
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "podman" ];

  disabledTests = [
    # Integration tests require a running container setup
    "AdapterIntegrationTest"
    "ContainersIntegrationTest"
    "ContainersExecIntegrationTests"
    "ImagesIntegrationTest"
    "ManifestsIntegrationTest"
    "NetworksIntegrationTest"
    "PodsIntegrationTest"
    "SecretsIntegrationTest"
    "SystemIntegrationTest"
    "VolumesIntegrationTest"
  ];

  meta = with lib; {
    description = "Python bindings for Podman's RESTful API";
    homepage = "https://github.com/containers/podman-py";
    changelog = "https://github.com/containers/podman-py/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

## AWS Neuron Deep Learning Containers

AWS Neuron Deep Learning Containers (DLCs) are a set of Docker images for training and serving models on AWS Trainium and Inferentia instances using AWS Neuron SDK. For more documentation, please refer to [Neuron Containers Overview](https://awsdocs-neuron.readthedocs-hosted.com/en/latest/containers/index.html).

## Building and Customizing Dockerfiles

### Prerequisites

To build the Dockerfiles successfully, ensure the files under the `common/` directory is in the same parent folder as the Dockerfile. The common directory contains shared scripts and configuration files required by all container builds.

### Building a Container

To build a specific container, navigate to the repository root and use Docker build with the appropriate context:

```bash
# Example: Build PyTorch 2.7.0 inference container
docker build -f pytorch/inference/2.7.0/Dockerfile.neuronx -t my-neuron-container .
```

### Customizing Containers

You can customize the containers by:

1. **Modifying existing Dockerfiles**: Edit the Dockerfile to add additional packages or configurations
2. **Creating derived images**: Use the pre-built containers as base images for your custom requirements
3. **Adding custom scripts**: Place additional scripts and reference them in your Dockerfile

For detailed customization examples and best practices, refer to the [Neuron DLC Customization Guide](https://awsdocs-neuron.readthedocs-hosted.com/en/latest/containers/dlc-then-customize-devflow.html#containers-dlc-then-customize-devflow).

## Containers

### pytorch-inference-neuron

| Framework                                                                                                                              | Neuron Packages                 | Neuron SDK Version | Supported EC2 Instance Types | Python Version Options | ECR Public URL                                                                           | Other Packages    |
|----------------------------------------------------------------------------------------------------------------------------------------|---------------------------------|--------------------|------------------------------|------------------------|------------------------------------------------------------------------------------------|-------------------|
| [PyTorch 1.13.1](https://github.com/aws-neuron/deep-learning-containers/blob/2.20.2/docker/pytorch/inference/1.13.1/Dockerfile.neuron) | aws-neuronx-tools, torch-neuron | Neuron 2.20.2      | inf1                         | 3.10 (py310)           | public.ecr.aws/neuron/pytorch-inference-neuron:1.13.1-neuron-py310-sdk2.20.2-ubuntu20.04 | torchserve 0.11.0 |

### pytorch-inference-neuronx

| Framework                                                                                                                               | Neuron Packages                                                             | Neuron SDK Version | Supported EC2 Instance Types | Python Version Options | ECR Public URL                                                                             | Other Packages    |
|-----------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|--------------------|------------------------------|------------------------|--------------------------------------------------------------------------------------------|-------------------|
| [PyTorch 2.9.0](https://github.com/aws-neuron/deep-learning-containers/blob/2.27.1/pytorch/inference/2.9.0/Dockerfile.neuronx)   | aws-neuronx-tools, neuronx_distributed, neuronx_distributed_inference, torch-neuronx | Neuron 2.27.1     | trn1,trn2,trn3,inf2                    | 3.12 (py312)           | public.ecr.aws/neuron/pytorch-inference-neuronx:2.9.0-neuronx-py312-sdk2.27.1-ubuntu24.04  | torchserve 0.11.0 |
| [PyTorch 2.8.0](https://github.com/aws-neuron/deep-learning-containers/blob/2.26.1/pytorch/inference/2.8.0/Dockerfile.neuronx)   | aws-neuronx-tools, neuronx_distributed, neuronx_distributed_inference, torch-neuronx | Neuron 2.26.1     | trn1,trn2,inf2                    | 3.11 (py311)           | public.ecr.aws/neuron/pytorch-inference-neuronx:2.8.0-neuronx-py311-sdk2.26.1-ubuntu22.04  | torchserve 0.11.0 |
| [PyTorch 2.7.0](https://github.com/aws-neuron/deep-learning-containers/blob/2.25.0/docker/pytorch/inference/2.7.0/Dockerfile.neuronx)   | aws-neuronx-tools, neuronx_distributed, neuronx_distributed_inference, torch-neuronx, transformers-neuronx | Neuron 2.25.0     | trn1,trn2,inf2                    | 3.10 (py310)           | public.ecr.aws/neuron/pytorch-inference-neuronx:2.7.0-neuronx-py310-sdk2.25.0-ubuntu22.04  | torchserve 0.11.0 |
| [PyTorch 2.6.0](https://github.com/aws-neuron/deep-learning-containers/blob/2.23.0/docker/pytorch/inference/2.6.0/Dockerfile.neuronx)   | aws-neuronx-tools, neuronx_distributed, neuronx_distributed_inference, torch-neuronx, transformers-neuronx | Neuron 2.23.0     | trn1,trn2,inf2                    | 3.10 (py310)           | public.ecr.aws/neuron/pytorch-inference-neuronx:2.6.0-neuronx-py310-sdk2.23.0-ubuntu22.04  | torchserve 0.11.0 |
| [PyTorch 2.5.1](https://github.com/aws-neuron/deep-learning-containers/blob/2.22.0/docker/pytorch/inference/2.5.1/Dockerfile.neuronx)   | aws-neuronx-tools, neuronx_distributed, neuronx_distributed_inference, torch-neuronx, transformers-neuronx | Neuron 2.22.0     | trn1,trn2,inf2                    | 3.10 (py310)           | public.ecr.aws/neuron/pytorch-inference-neuronx:2.5.1-neuronx-py310-sdk2.22.0-ubuntu22.04  | torchserve 0.11.0 |
| [PyTorch 2.1.2](https://github.com/aws-neuron/deep-learning-containers/blob/2.20.2/docker/pytorch/inference/2.1.2/Dockerfile.neuronx)   | aws-neuronx-tools, neuronx_distributed, torch-neuronx, transformers-neuronx | Neuron 2.20.2      | trn1,inf2                    | 3.10 (py310)           | public.ecr.aws/neuron/pytorch-inference-neuronx:2.1.2-neuronx-py310-sdk2.20.2-ubuntu20.04  | torchserve 0.11.0 |
| [PyTorch 1.13.1](https://github.com/aws-neuron/deep-learning-containers/blob/2.20.2/docker/pytorch/inference/1.13.1/Dockerfile.neuronx) | aws-neuronx-tools, neuronx_distributed, torch-neuronx, transformers-neuronx | Neuron 2.20.2      | trn1,inf2                    | 3.10 (py310)           | public.ecr.aws/neuron/pytorch-inference-neuronx:1.13.1-neuronx-py310-sdk2.20.2-ubuntu20.04 | torchserve 0.11.0 |

### pytorch-training-neuronx

| Framework                                                                                                                              | Neuron Packages                                       | Neuron SDK Version | Supported EC2 Instance Types | Python Version Options | ECR Public URL                                                                            |
|----------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------|--------------------|------------------------------|------------------------|-------------------------------------------------------------------------------------------|
| [PyTorch 2.9.0](https://github.com/aws-neuron/deep-learning-containers/blob/2.27.1/pytorch/training/2.9.0/Dockerfile.neuronx)   | aws-neuronx-tools, neuronx_distributed, neuronx_distributed_training, torch-neuronx | Neuron 2.27.1      | trn1,trn2,trn3,inf2                    | 3.12 (py312)           | public.ecr.aws/neuron/pytorch-training-neuronx:2.9.0-neuronx-py312-sdk2.27.1-ubuntu24.04  |
| [PyTorch 2.8.0](https://github.com/aws-neuron/deep-learning-containers/blob/2.26.1/pytorch/training/2.8.0/Dockerfile.neuronx)   | aws-neuronx-tools, neuronx_distributed, neuronx_distributed_training, torch-neuronx | Neuron 2.26.1      | trn1,trn2,inf2                    | 3.11 (py311)           | public.ecr.aws/neuron/pytorch-training-neuronx:2.8.0-neuronx-py311-sdk2.26.1-ubuntu22.04  |
| [PyTorch 2.7.0](https://github.com/aws-neuron/deep-learning-containers/blob/2.25.0/docker/pytorch/training/2.7.0/Dockerfile.neuronx)   | aws-neuronx-tools, neuronx_distributed, neuronx_distributed_training, torch-neuronx | Neuron 2.25.0      | trn1,trn2,inf2                    | 3.10 (py310)           | public.ecr.aws/neuron/pytorch-training-neuronx:2.7.0-neuronx-py310-sdk2.25.0-ubuntu22.04  |
| [PyTorch 2.6.0](https://github.com/aws-neuron/deep-learning-containers/blob/2.23.0/docker/pytorch/training/2.6.0/Dockerfile.neuronx)   | aws-neuronx-tools, neuronx_distributed, neuronx_distributed_training, torch-neuronx | Neuron 2.23.0      | trn1,trn2,inf2                    | 3.10 (py310)           | public.ecr.aws/neuron/pytorch-training-neuronx:2.6.0-neuronx-py310-sdk2.23.0-ubuntu22.04  |
| [PyTorch 2.5.1](https://github.com/aws-neuron/deep-learning-containers/blob/2.22.0/docker/pytorch/training/2.5.1/Dockerfile.neuronx)   | aws-neuronx-tools, neuronx_distributed, neuronx_distributed_training, torch-neuronx | Neuron 2.22.0      | trn1,trn2,inf2                    | 3.10 (py310)           | public.ecr.aws/neuron/pytorch-training-neuronx:2.5.1-neuronx-py310-sdk2.22.0-ubuntu22.04  |
| [PyTorch 2.1.2](https://github.com/aws-neuron/deep-learning-containers/blob/2.20.2/docker/pytorch/training/2.1.2/Dockerfile.neuronx)   | aws-neuronx-tools, neuronx_distributed, neuronx_distributed_training, torch-neuronx | Neuron 2.20.2      | trn1,inf2                    | 3.10 (py310)           | public.ecr.aws/neuron/pytorch-training-neuronx:2.1.2-neuronx-py310-sdk2.20.2-ubuntu20.04  |
| [PyTorch 1.13.1](https://github.com/aws-neuron/deep-learning-containers/blob/2.20.2/docker/pytorch/training/1.13.1/Dockerfile.neuronx) | aws-neuronx-tools, neuronx_distributed, neuronx_distributed_training, torch-neuronx | Neuron 2.20.2      | trn1,inf2                    | 3.10 (py310)           | public.ecr.aws/neuron/pytorch-training-neuronx:1.13.1-neuronx-py310-sdk2.20.2-ubuntu20.04 |

### jax-training-neuronx

| Framework                                                                                                                              | Neuron Packages                 | Neuron SDK Version | Supported EC2 Instance Types | Python Version Options | ECR Public URL                                                                           | Other Packages    |
|----------------------------------------------------------------------------------------------------------------------------------------|---------------------------------|--------------------|------------------------------|------------------------|------------------------------------------------------------------------------------------|-------------------|
| [JAX 0.7](https://github.com/aws-neuron/deep-learning-containers/blob/2.27.1/jax/training/0.7/Dockerfile.neuronx) | jax-neuronx, libneuronxla | Neuron 2.27.1      | trn1,trn2,trn3,inf2                        | 3.12 (py312)           | public.ecr.aws/neuron/jax-training-neuronx:0.7-neuronx-py312-sdk2.27.1-ubuntu24.04 | jaxlib 0.7 |
| [JAX 0.6](https://github.com/aws-neuron/deep-learning-containers/blob/2.26.1/jax/training/0.6/Dockerfile.neuronx) | jax-neuronx, libneuronxla | Neuron 2.26.1      | trn1,trn2,inf2                        | 3.11 (py311)           | public.ecr.aws/neuron/jax-training-neuronx:0.6-neuronx-py311-sdk2.26.1-ubuntu22.04 | jaxlib 0.6 |
| [JAX 0.6](https://github.com/aws-neuron/deep-learning-containers/blob/2.25.0/docker/jax/training/0.6/Dockerfile.neuronx) | jax-neuronx, libneuronxla | Neuron 2.25.0      | trn1,trn2,inf2                        | 3.10 (py310)           | public.ecr.aws/neuron/jax-training-neuronx:0.6-neuronx-py310-sdk2.25.0-ubuntu22.04 | jaxlib 0.6 |
| [JAX 0.5](https://github.com/aws-neuron/deep-learning-containers/blob/2.23.0/docker/jax/training/0.5/Dockerfile.neuronx) | jax-neuronx, libneuronxla | Neuron 2.23.0      | trn1,trn2,inf2                        | 3.10 (py310)           | public.ecr.aws/neuron/jax-training-neuronx:0.5-neuronx-py310-sdk2.23.0-ubuntu22.04 | jaxlib 0.5 |

### vllm-inference-neuronx

| Framework                                                                                                                              | Neuron Packages                                       | Neuron SDK Version | Supported EC2 Instance Types | Python Version Options | ECR Public URL                                                                            |
|----------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------|--------------------|------------------------------|------------------------|-------------------------------------------------------------------------------------------|
| [VLLM 0.13.0](https://github.com/aws-neuron/deep-learning-containers/blob/2.27.1/vllm/inference/0.13.0/Dockerfile.neuronx) | vllm-neuronx, libneuronxla, neuronx_distributed, neuronx_distributed_inference, torch-neuronx, aws-neuronx-tools, nki | Neuron 2.27.1      | trn1,trn2,trn3,inf2     | 3.12 (py312)           | public.ecr.aws/neuron/pytorch-inference-vllm-neuronx:0.13.0-neuronx-py312-sdk2.27.1-ubuntu24.04 |
| [VLLM 0.11.0](https://github.com/aws-neuron/deep-learning-containers/blob/2.27.1/vllm/inference/0.11.0/Dockerfile.neuronx) | vllm-neuronx, libneuronxla, neuronx_distributed, neuronx_distributed_inference, torch-neuronx, aws-neuronx-tools | Neuron 2.27.1      | trn1,trn2,trn3,inf2     | 3.12 (py312)           | public.ecr.aws/neuron/pytorch-inference-vllm-neuronx:0.11.0-neuronx-py312-sdk2.27.1-ubuntu24.04 |
| [VLLM 0.9](https://github.com/aws-neuron/deep-learning-containers/blob/2.26.1/vllm/inference/0.9.1/Dockerfile.neuronx) | vllm-neuronx, libneuronxla, neuronx_distributed, neuronx_distributed_inference, torch-neuronx, aws-neuronx-tools | Neuron 2.26.1      | trn1,trn2,inf2                        | 3.11 (py311)           | public.ecr.aws/neuron/pytorch-inference-vllm-neuronx:0.9.1-neuronx-py311-sdk2.26.1-ubuntu22.04 |
| [VLLM 0.9](https://github.com/aws-neuron/deep-learning-containers/blob/2.25.0/docker/vllm/inference/0.9.1/Dockerfile.neuronx) | vllm-neuronx, libneuronxla, neuronx_distributed, neuronx_distributed_inference, torch-neuronx, aws-neuronx-tools | Neuron 2.25.0      | trn1,trn2,inf2                        | 3.10 (py310)           | public.ecr.aws/neuron/pytorch-inference-vllm-neuronx:0.9.1-neuronx-py310-sdk2.25.0-ubuntu22.04 |
| [VLLM 0.7](https://github.com/aws-neuron/deep-learning-containers/blob/2.24.1/docker/vllm/inference/0.7.2/Dockerfile.neuronx) | vllm-neuronx, libneuronxla, neuronx_distributed, neuronx_distributed_inference, torch-neuronx, aws-neuronx-tools | Neuron 2.24.1      | trn1,trn2,inf2                        | 3.10 (py310)           | public.ecr.aws/neuron/pytorch-inference-vllm-neuronx:0.7.2-neuronx-py310-sdk2.24.1-ubuntu22.04 |

## Security

See [SECURITY](SECURITY.md) for more information.

## License

This project is licensed under the Apache-2.0 License.

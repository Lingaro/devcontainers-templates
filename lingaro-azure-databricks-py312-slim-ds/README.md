# Lingaro Azure Databricks DevContainer Template

A high-performance, optimized DevContainer template for data scientists with Azure, Databricks integration, and advanced caching.

## 🚀 Quick Start

1. **Clone and Navigate**: 
   ```bash
   git clone <repo-url>
   cd lingaro-azure-databricks-py312-slim-ds
   ```

2. **Configure Environment**: 
   ```bash
   cp .env.example .env
   # update credentials and tokens in .env
   ```

3. **Build with Caching**: 
   ```bash
   docker compose build
   docker compose up -d
   ```

4. **Connect to Container**: 
   ```bash
   docker exec -it lingaro-azure-databricks-py312-slim-ds zsh
   ```

5. **Ready to Go**: 
   - Jupyter Lab: http://localhost:8888
   - MLflow UI: http://localhost:5000

## 🚀 Performance Optimizations

### Docker Layer Caching
- **Smart layer ordering**: System packages → UV → Requirements → Azure CLI → Zsh → Scripts
- **Persistent package cache**: UV and pip caches preserved between builds
- **Build time**: First build ~80s, subsequent builds ~1s (with cache)

### Shell Enhancements
- **Zsh with Oh My Zsh**: Modern shell with auto-suggestions and syntax highlighting
- **Smart history**: 10,000 lines with deduplication and timestamps
- **Development aliases**: Docker, Python, Git, Azure shortcuts
- **Plugin-based**: Modular Zsh configuration script

## 📦 What's Included

### VS Code Extensions (Recommended)
- **Databricks** - `databricks.databricks`
- **Azure ML** - `ms-azuretools.vscode-azureml`
- **Jupyter** - `ms-toolsai.jupyter`
- **Python** - `ms-python.python`
- **Git** - `eamodio.gitlens`

### Python Libraries (Pre-installed)
- **Core DS Stack**: pandas, numpy, scikit-learn, scipy
- **ML/DL**: torch, transformers, accelerate, peft
- **Experiment Tracking**: MLflow with UI
- **Fast Fine-tuning**: Unsloth (x86_64 only, PEFT fallback for ARM64)
- **Package Manager**: UV for fast installations
- **Git LFS**: Ready for Hugging Face models
- **Jupyter Lab**: Interactive notebooks
- **Azure ML & Databricks**: Full cloud integrations

### System Features
- **Azure CLI**: Latest version with script-based installation
- **Zsh Shell**: Oh My Zsh with plugins (autosuggestions, syntax highlighting, history search)
- **Smart Service Management**: Automatic Jupyter Lab and MLflow startup
- **Optimized Logging**: Consolidated service status and configuration checks

### Auto-configuration
- ✅ Git LFS ready for Hugging Face models
- ✅ Jupyter Lab on port 8888
- ✅ MLflow UI on port 5000
- ✅ Optimal device detection (MPS > CUDA > CPU)
- ✅ Azure ML workspace connection
- ✅ Databricks connection

## 🔧 Configuration

### Environment Variables
Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
# Edit .env with your credentials
```

### Azure CLI Setup
```bash
# In the container - Azure CLI is pre-installed
az login
az account show  # Check current subscription
```

### Databricks Setup
```bash
# Configure Databricks CLI
databricks configure --token
# Or set environment variables:
export DATABRICKS_HOST="your-workspace-url"
export DATABRICKS_TOKEN="your-token"
```

### Zsh Features (Pre-configured)
- **Auto-suggestions**: Type commands and see suggestions based on history
- **Syntax highlighting**: Valid commands highlighted in green, invalid in red
- **History search**: Use ↑/↓ arrows to search through command history
- **Development aliases**: `dc` (docker-compose), `py` (python), `k` (kubectl), etc.

## 🧪 Testing

### Quick Environment Test
```python
# Test optimal device detection
import torch

def get_optimal_device():
    if hasattr(torch.backends, 'mps') and torch.backends.mps.is_available() and torch.backends.mps.is_built():
        return torch.device("mps")
    elif torch.cuda.is_available():
        return torch.device("cuda")
    else:
        return torch.device("cpu")

device = get_optimal_device()
print(f"Using device: {device}")

# Test tensor creation
x = torch.randn(10, 10, device=device)
print(f"✅ Tensor created on {x.device}")
```

### Test Unsloth Import
```python
try:
    from unsloth import FastLanguageModel
    print("✅ Unsloth imported successfully")
except ImportError as e:
    print(f"⚠️ Unsloth not available: {e}")
    print("💡 Using transformers + PEFT as alternative")
```

### Test MLflow
```python
import mlflow

# Start experiment
mlflow.set_experiment("test_experiment")

with mlflow.start_run():
    mlflow.log_param("model", "test")
    mlflow.log_metric("accuracy", 0.95)
    print("✅ MLflow logging successful")
```

## 🌍 Device Compatibility

| Platform | Device | Performance | Notes |
|----------|---------|------------|-------|
| Apple Silicon (native) | MPS | Excellent | Full GPU acceleration |
| Apple Silicon (Docker) | CPU | Very Good | Python 3.12 optimizations |
| NVIDIA GPU | CUDA | Excellent | Full GPU acceleration |
| Intel/AMD CPU | CPU | Good | Standard CPU performance |

## 📁 File Structure

```
lingaro-azure-databricks-py312-slim-ds/
├── scripts/
│   ├── post-attach.sh             # Configuration checks on attach
│   ├── post-create.sh             # One-time setup after creation
│   ├── post-start.sh              # Service startup script
│   └── setup-zsh.sh               # Oh My Zsh configuration
├── .env.example                   # Environment variables template
├── docker-compose.yml             # Docker Compose with caching
├── Dockerfile                     # Optimized container definition
├── requirements.txt               # Python dependencies
└── README.md                      # This file
```

## 🚀 Performance Features

### Docker Optimizations
- **Layer Caching**: Optimized layer order for maximum cache efficiency
- **UV Package Manager**: 10-100x faster than pip for package installation
- **Persistent Volumes**: Package caches preserved between container rebuilds
- **Smart Rebuilds**: Only affected layers are rebuilt when files change

### Shell Experience
- **Oh My Zsh**: Modern shell framework with themes and plugins
- **Development Aliases**: Quick shortcuts for common development tasks
- **History Management**: 10,000 lines with intelligent search and deduplication
- **Auto-completion**: Context-aware tab completion for Git, Docker, Python, Azure

### Custom Model Fine-tuning
```python
from transformers import AutoTokenizer, AutoModelForCausalLM
from peft import LoraConfig, get_peft_model

# Load model with optimal device
device = get_optimal_device()
model = AutoModelForCausalLM.from_pretrained("microsoft/DialoGPT-medium")
model = model.to(device)

# Add LoRA for efficient fine-tuning
lora_config = LoraConfig(
    r=16,
    lora_alpha=32,
    target_modules=["c_attn"],
    lora_dropout=0.1,
    bias="none",
    task_type="CAUSAL_LM"
)

model = get_peft_model(model, lora_config)
```

### Git LFS for Large Models
```bash
# Clone a model with LFS
git clone https://huggingface.co/microsoft/DialoGPT-large
cd DialoGPT-large

# LFS files are automatically handled
git lfs pull
```

## 🔍 Troubleshooting

### Container Name Conflicts
```bash
# If you get "container name already in use" error:
docker stop lingaro-datascience-simple
docker rm lingaro-datascience-simple
docker compose up -d
```

### Build Cache Issues
```bash
# Force rebuild without cache
docker compose build --no-cache

# Clean up old images
docker system prune
```

### Service Startup Issues
```bash
# Check service logs
docker logs lingaro-datascience-simple

# Check service status
docker exec -it lingaro-datascience-simple ps aux | grep -E "(jupyter|mlflow)"
```

### Package Installation Issues
```bash
# Use UV for faster installs
uv pip install package-name

# Clear UV cache if needed
uv cache clean
```

### Zsh Configuration
```bash
# Reload Zsh configuration
source ~/.zshrc

# Check Oh My Zsh status
echo $ZSH_VERSION
```

## 💡 Performance Tips

- **First Build**: Allow ~80 seconds for initial package downloads
- **Subsequent Builds**: Leverage Docker cache for ~1 second rebuilds
- **Memory**: Adjust Docker memory limits in docker-compose.yml for large models
- **Persistence**: Use volumes for model checkpoints and data
- **Extensions**: Install additional VS Code extensions as needed
- **Shell**: Use Zsh aliases like `dc` for docker-compose, `py` for python
- **Package Management**: Prefer `uv pip install` over regular `pip` for speed

## 🎯 Key Features Summary

| Feature | Benefit | Implementation |
|---------|---------|----------------|
| **Docker Caching** | 98% faster rebuilds | Optimized layer ordering |
| **UV Package Manager** | 10-100x faster installs | Python 3.12 + UV integration |
| **Zsh + Oh My Zsh** | Enhanced developer experience | Auto-suggestions, syntax highlighting |
| **Azure CLI** | Cloud integration | Script-based installation (compatible with all Debian versions) |
| **Smart Services** | Auto-startup with status checks | Jupyter Lab + MLflow pre-configured |
| **Modular Scripts** | Easy maintenance | Separate post-create, post-start, post-attach scripts |

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Test with different platforms
4. Submit a pull request

## 📄 License

This template is provided under the MIT License.

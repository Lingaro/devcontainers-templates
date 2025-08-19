#!/usr/bin/env python3
"""
Environment Comparison Script
=============================

This script helps you understand the performance differences between:
1. Docker Container (CPU-only)
2. Native macOS (with potential MPS support)

Run this script in both environments to compare performance.
"""

import torch
import time
import sys
import platform
import os


def detect_environment():
    """Detect the current environment and capabilities."""
    print("🔍 Environment Detection")
    print("=" * 50)
    
    # Basic info
    print(f"Python: {sys.version}")
    print(f"Platform: {platform.platform()}")
    print(f"PyTorch: {torch.__version__}")
    
    # Container detection
    is_container = os.path.exists('/.dockerenv')
    print(f"Container: {is_container}")
    
    # Device capabilities
    devices = {}
    
    # CPU
    devices['cpu'] = {
        'available': True,
        'name': 'CPU',
        'description': f"Python {sys.version_info.major}.{sys.version_info.minor}"
    }
    
    # MPS (Apple Silicon)
    if hasattr(torch.backends, 'mps'):
        mps_available = torch.backends.mps.is_available() and torch.backends.mps.is_built()
        devices['mps'] = {
            'available': mps_available,
            'name': 'Apple Silicon GPU (MPS)',
            'description': 'Metal Performance Shaders'
        }
    
    # CUDA
    cuda_available = torch.cuda.is_available()
    devices['cuda'] = {
        'available': cuda_available,
        'name': 'NVIDIA GPU (CUDA)',
        'description': f'CUDA {torch.version.cuda}' if cuda_available else 'Not available'
    }
    
    print(f"\n📋 Available Devices:")
    for device_type, info in devices.items():
        status = "✅" if info['available'] else "❌"
        print(f"   {status} {info['name']}: {info['description']}")
    
    return devices


def benchmark_device(device_name, sizes=[512, 1024, 2048]):
    """Benchmark matrix multiplication on a specific device."""
    try:
        device = torch.device(device_name)
        print(f"\n⚡ Benchmarking {device_name.upper()} Performance")
        print("-" * 40)
        
        results = {}
        
        for size in sizes:
            print(f"Testing {size}x{size} matrix multiplication...")
            
            # Create random matrices
            x = torch.randn(size, size, device=device)
            y = torch.randn(size, size, device=device)
            
            # Warm up
            torch.matmul(x, y)
            
            # Benchmark
            iterations = 3
            start_time = time.time()
            
            for _ in range(iterations):
                result = torch.matmul(x, y)
                
            # Ensure completion (important for GPU)
            if device.type == 'mps':
                torch.mps.synchronize()
            elif device.type == 'cuda':
                torch.cuda.synchronize()
            
            end_time = time.time()
            avg_time = (end_time - start_time) / iterations
            
            # Calculate GFLOPS (Giga Floating Point Operations Per Second)
            flops = (size ** 3) * 2  # Matrix multiplication FLOPS
            gflops = flops / avg_time / 1e9
            
            results[size] = {
                'time': avg_time,
                'gflops': gflops
            }
            
            print(f"   {size}x{size}: {avg_time:.4f}s ({gflops:.2f} GFLOPS)")
        
        return results
        
    except Exception as e:
        print(f"❌ Failed to benchmark {device_name}: {e}")
        return None


def main():
    """Main comparison function."""
    print("🚀 Environment Performance Comparison")
    print("=" * 60)
    
    # Detect environment
    devices = detect_environment()
    
    # Benchmark available devices
    all_results = {}
    
    # Always benchmark CPU
    cpu_results = benchmark_device('cpu')
    if cpu_results:
        all_results['CPU'] = cpu_results
    
    # Benchmark MPS if available
    if devices.get('mps', {}).get('available'):
        mps_results = benchmark_device('mps')
        if mps_results:
            all_results['MPS (Apple GPU)'] = mps_results
    
    # Benchmark CUDA if available
    if devices.get('cuda', {}).get('available'):
        cuda_results = benchmark_device('cuda')
        if cuda_results:
            all_results['CUDA (NVIDIA GPU)'] = cuda_results
    
    # Summary
    print(f"\n📊 Performance Summary")
    print("=" * 60)
    
    if len(all_results) > 1:
        # Compare performance
        print("Matrix Size | Device           | Time (s) | GFLOPS | Speedup")
        print("-" * 60)
        
        for size in [512, 1024, 2048]:
            first_device = True
            cpu_time = all_results.get('CPU', {}).get(size, {}).get('time', 1.0)
            
            for device_name, results in all_results.items():
                if size in results:
                    time_taken = results[size]['time']
                    gflops = results[size]['gflops']
                    speedup = cpu_time / time_taken if device_name != 'CPU' else 1.0
                    
                    speedup_str = f"{speedup:.1f}x" if speedup != 1.0 else "baseline"
                    print(f"{size:>11} | {device_name:<16} | {time_taken:>8.4f} | {gflops:>6.1f} | {speedup_str}")
    
    # Recommendations
    print(f"\n💡 Recommendations")
    print("=" * 60)
    
    if devices.get('mps', {}).get('available'):
        print("✅ MPS Available: Use native macOS for GPU-accelerated workloads")
        print("   • Training large models: 2-10x faster than CPU")
        print("   • Inference: Significant speedup for large tensors")
        print("   • Memory: More efficient for large models")
    else:
        is_container = os.path.exists('/.dockerenv')
        if is_container:
            print("🐳 Container Environment: Excellent for development")
            print("   • CPU performance: Optimized with Python 3.12")
            print("   • Reproducibility: Consistent across machines")
            print("   • For GPU needs: Consider native macOS setup")
        else:
            print("💻 Native Environment: CPU-only on this system")
            print("   • Good for: Data processing, small models")
            print("   • Consider: Upgrading to Apple Silicon for MPS")
    
    print(f"\n🎯 Best Practice:")
    print("   • Development & Testing: Docker containers")
    print("   • Training & Inference: Native macOS (if MPS available)")
    print("   • Production: Containerized deployment")


if __name__ == "__main__":
    main()

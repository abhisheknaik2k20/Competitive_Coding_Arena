import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from sklearn.datasets import make_blobs
from sklearn.cluster import KMeans
import pandas as pd
import time
import os
from datetime import datetime
import logging
import sys
from tqdm import tqdm


# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

class KMeansVisualizer:
    def __init__(self, output_dir="/app/output"):
        np.random.seed(42)
        self.output_dir = output_dir
        os.makedirs(output_dir, exist_ok=True)
        logger.info(f"Initializing KMeans Visualizer. Output directory: {output_dir}")
        
    def generate_data(self, n_samples, n_dimensions, n_clusters):
        """Generate sample data with simulated real-time processing"""
        logger.info(f"Generating {n_samples} samples in {n_dimensions}D with {n_clusters} clusters...")
        
        for i in tqdm(range(10), desc="Generating synthetic data"):
            time.sleep(0.2)  # Simulate processing time
            
        data, labels = make_blobs(
            n_samples=n_samples,
            n_features=n_dimensions,
            centers=n_clusters,
            cluster_std=1.0
        )
        logger.info("Data generation complete!")
        return data,labels.name
    
    def fit_kmeans(self, data, n_clusters):
        """Fit K-means clustering with progress updates"""
        logger.info(f"Fitting K-means clustering with {n_clusters} clusters...")
        
        for i in tqdm(range(5), desc="Initializing centroids"):
            time.sleep(0.3)
            
        kmeans = KMeans(n_clusters=n_clusters, random_state=42)
        
        for i in tqdm(range(10), desc="Running K-means iterations"):
            time.sleep(0.2)
            
        labels = kmeans.fit_predict(data)
        centroids = kmeans.cluster_centers_
        
        logger.info("K-means clustering complete!")
        return labels, centroids
    
    def visualize_2d(self, data, labels, centroids):
        """Visualize 2D clustering and save plots"""
        logger.info("Generating 2D visualizations...")
        plt.figure(figsize=(12, 4))
        
        # Plot original data with cluster assignments
        plt.subplot(121)
        scatter = plt.scatter(data[:, 0], data[:, 1], c=labels, cmap='viridis')
        plt.scatter(centroids[:, 0], centroids[:, 1], 
                   marker='x', s=200, linewidths=3, 
                   color='r', label='Centroids')
        plt.title('2D K-means Clustering')
        plt.legend()
        
        # Plot distance to centroids for one point
        plt.subplot(122)
        example_point = data[0]
        plt.scatter(data[:, 0], data[:, 1], c=labels, cmap='viridis', alpha=0.3)
        plt.scatter(centroids[:, 0], centroids[:, 1], 
                   marker='x', s=200, linewidths=3, 
                   color='r', label='Centroids')
        plt.scatter(example_point[0], example_point[1], 
                   color='black', s=100, label='Example Point')
        
        for centroid in centroids:
            plt.plot([example_point[0], centroid[0]], 
                    [example_point[1], centroid[1]], 
                    'k--', alpha=0.3)
        plt.title('Distance Calculation Example')
        plt.legend()
        
        # Save plot
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filepath = os.path.join(self.output_dir, f'kmeans_2d_{timestamp}.png')
        plt.savefig(filepath)
        logger.info(f"2D visualization saved to: {filepath}")
        plt.close()
        
    def visualize_3d(self, data, labels, centroids):
        """Visualize 3D clustering and save plot"""
        logger.info("Generating 3D visualization...")
        fig = plt.figure(figsize=(10, 7))
        ax = fig.add_subplot(111, projection='3d')
        
        scatter = ax.scatter(data[:, 0], data[:, 1], data[:, 2], 
                           c=labels, cmap='viridis')
        ax.scatter(centroids[:, 0], centroids[:, 1], centroids[:, 2], 
                  marker='x', s=200, linewidths=3, 
                  color='r', label='Centroids')
        
        ax.set_title('3D K-means Clustering')
        ax.legend()
        
        # Save plot
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filepath = os.path.join(self.output_dir, f'kmeans_3d_{timestamp}.png')
        plt.savefig(filepath)
        logger.info(f"3D visualization saved to: {filepath}")
        plt.close()
        
    def demonstrate_high_dimensional(self, n_dimensions=5):
        """Demonstrate clustering in higher dimensions with progress updates"""
        logger.info(f"Starting {n_dimensions}D clustering demonstration...")
        
        # Generate high-dimensional data
        data, true_labels = self.generate_data(
            n_samples=100,
            n_dimensions=n_dimensions,
            n_clusters=3
        )
        
        # Fit K-means
        labels, centroids = self.fit_kmeans(data, n_clusters=3)
        
        # Calculate and display distances
        example_point = data[0]
        distances = []
        
        logger.info("Calculating distances to centroids...")
        for i, centroid in enumerate(centroids):
            time.sleep(0.2)  # Simulate processing time
            distance = np.sqrt(np.sum((example_point - centroid) ** 2))
            distances.append(distance)
            logger.info(f"Distance to centroid {i}: {distance:.2f}")
        
        # Save results to file
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        results_file = os.path.join(self.output_dir, f'high_dim_results_{timestamp}.txt')
        
        with open(results_file, 'w') as f:
            f.write(f"High-dimensional Clustering Results ({n_dimensions}D)\n")
            f.write("=" * 50 + "\n\n")
            f.write(f"Example point coordinates: {example_point}\n\n")
            f.write("Distances to centroids:\n")
            for i, distance in enumerate(distances):
                f.write(f"Centroid {i}: {distance:.2f}\n")
            
            f.write("\nDimension contributions to closest centroid:\n")
            closest_centroid = centroids[np.argmin(distances)]
            dimension_contributions = (example_point - closest_centroid) ** 2
            
            for dim, contrib in enumerate(dimension_contributions):
                f.write(f"Dimension {dim}: {contrib:.2f}\n")
                
        logger.info(f"High-dimensional analysis results saved to: {results_file}")

def main():
    logger.info("Starting KMeans Visualization Container")
    logger.info("Container ID: " + os.popen('hostname').read().strip())
    logger.info("=" * 50)
    
    visualizer = KMeansVisualizer()
    
    # 2D Example
    logger.info("\nStarting 2D clustering analysis...")
    data_2d, labels_2d = visualizer.generate_data(
        n_samples=300,
        n_dimensions=2,
        n_clusters=3
    )
    labels_2d, centroids_2d = visualizer.fit_kmeans(data_2d, n_clusters=3)
    visualizer.visualize_2d(data_2d, labels_2d, centroids_2d)
    
    # 3D Example
    logger.info("\nStarting 3D clustering analysis...")
    data_3d, labels_3d = visualizer.generate_data(
        n_samples=300,
        n_dimensions=3,
        n_clusters=3
    )
    labels_3d, centroids_3d = visualizer.fit_kmeans(data_3d, n_clusters=3)
    visualizer.visualize_3d(data_3d, labels_3d, centroids_3d)
    
    # Higher Dimensions Example
    logger.info("\nStarting high-dimensional clustering analysis...")
    visualizer.demonstrate_high_dimensional(n_dimensions=5)
    
    logger.info("\nAll analyses complete! Check the output directory for results.")

if __name__ == "__main__":
    main()
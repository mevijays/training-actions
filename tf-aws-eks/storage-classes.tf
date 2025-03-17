resource "kubernetes_storage_class" "gp3" {
  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  
  parameters = {
    type        = "gp3"
    fsType      = "ext4"
    encrypted   = "true"
    iops        = "3000"
    throughput  = "125"
  }

  depends_on = [
    module.eks.cluster_id,
    null_resource.wait_for_cluster
  ]
}

resource "null_resource" "wait_for_cluster" {
  depends_on = [
    module.eks.cluster_id
  ]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = <<-EOT
      echo "Waiting for EKS cluster to be ready..."
      
      # Wait for up to 5 minutes (30 x 10 seconds)
      for i in {1..30}; do
        if aws eks describe-cluster --name ${module.eks.cluster_name} --query "cluster.status" --output text | grep -q "ACTIVE"; then
          echo "EKS cluster is ready!"
          exit 0
        fi
        echo "Waiting for EKS cluster to be ready... ($i/30)"
        sleep 10
      done
      
      echo "Timed out waiting for EKS cluster to be ready"
      exit 1
    EOT
  }
}

# Optional: Mark gp2 as non-default
resource "kubernetes_annotations" "gp2_non_default" {
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  metadata {
    name = "gp2"
  }
  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "false"
  }

  depends_on = [
    kubernetes_storage_class.gp3
  ]
}
apiVersion: v1
kind: Pod
metadata:
  name: backend
  namespace: three-tier
spec:
  containers:
  - name: backend
    image: ${backend_image_url}
    ports:
    - containerPort: 5000

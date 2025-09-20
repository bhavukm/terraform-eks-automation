apiVersion: v1
kind: Pod
metadata:
  name: frontend
  namespace: three-tier
spec:
  containers:
  - name: frontend
    image: ${frontend_image_url}
    ports:
    - containerPort: 80

echo "================================="
echo "Build Docker Images"
echo "================================="
echo ""

echo "[0/3] Setting up Minikube Docker environment..."
eval $(minikube docker-env)
echo "✅ Using Docker host: $DOCKER_HOST"
echo ""

# Web Application
echo "[1/3] Building web-app..."
docker build -t web-app:latest ./web
echo "✅ web-app built"
echo ""

# Database
echo "[2/3] Building database..."
docker build -t mysql-custom:latest ./db
echo "✅ database built"
echo ""

# Fuzzer
echo "[3/3] Building fuzzer..."
docker build -t fuzzer:latest -f dockerfile.fuzzer .
echo "✅ fuzzer built"
echo ""

echo "================================="
echo "Build Complete!"
echo "================================="
echo ""

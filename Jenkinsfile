def gitCommit() {
    sh "git rev-parse HEAD > GIT_COMMIT"
def gitCommit = readFile('GIT_COMMIT').trim()
    sh "rm -f GIT_COMMIT"
    return gitCommit
}

node {
    // Checkout source code from Git
    stage 'Checkout'
    checkout scm
    
    stage 'Setup'
    sh "killall dockerd || true"
    sh "sleep 15"
    sh "echo '{\n\t\"insecure-registries\" : [ \"registry.marathon.l4lb.thisdcos.directory:5000\" ]\n}' > /etc/docker/daemon.json"
    sh "dockerd &"
    sh "sleep 15"

    // Build Docker image
    stage 'Build'
    sh "docker build -t registry.marathon.l4lb.thisdcos.directory:5000/summit2:${gitCommit()} ."

    // Log in and push image to registry
    stage 'Publish'
    sh "docker push registry.marathon.l4lb.thisdcos.directory:5000/summit2:${gitCommit()}"

    // Test links in file
    stage 'Test'
    sh "docker run -p 8085:80 -d --name=test-container-${env.BUILD_NUMBER} registry.marathon.l4lb.thisdcos.directory:5000/summit2:${gitCommit()}"
    sh "docker exec test-container-${env.BUILD_NUMBER} linkchecker /usr/share/nginx/html/index.html"
    sh "docker kill test-container-${env.BUILD_NUMBER}"
    sh "docker rm test-container-${env.BUILD_NUMBER}"

    // Deploy
    stage 'Deploy'

    marathon(
        url: 'http://marathon.mesos:8080',
        forceUpdate: false,
        filename: 'marathon.json',
        id: 'summit2',
        docker: "registry.marathon.l4lb.thisdcos.directory:5000/summit2:${gitCommit()}".toString()
    )
}

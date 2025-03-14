FROM public.ecr.aws/lambda/provided:al2

# Install necessary compilers and interpreters
RUN yum update -y && \
    yum install -y python3 gcc-c++ wget tar gzip

# Install Java 11 (includes javac compiler)
RUN yum install -y java-11-amazon-corretto-headless

# Install Go 1.21
RUN wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz && \
    rm go1.21.5.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Set working directory
WORKDIR /var/task

# Copy go.mod and go.sum
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy function code
COPY main.go .

# Build the Go application
RUN go build -o bootstrap main.go

# Copy bootstrap to the location Lambda expects
RUN cp bootstrap /var/runtime/bootstrap && chmod 755 /var/runtime/bootstrap

# Verify Java and Javac installation
RUN java -version && javac -version

# Set the CMD to the bootstrap file
CMD ["/var/runtime/bootstrap"]
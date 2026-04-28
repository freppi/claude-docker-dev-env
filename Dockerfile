FROM node:20-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    curl \
    nano \
    apt-transport-https \
 && rm -rf /var/lib/apt/lists/*

# Add Microsoft package repo
RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb \
 && dpkg -i packages-microsoft-prod.deb \
 && rm packages-microsoft-prod.deb

# Install .NET SDK
RUN apt-get update && apt-get install -y dotnet-sdk-8.0

RUN npm install -g @anthropic-ai/claude-code

WORKDIR /workspace

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

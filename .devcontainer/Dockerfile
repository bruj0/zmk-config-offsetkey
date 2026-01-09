FROM docker.io/zmkfirmware/zmk-dev-arm:stable

USER root

# Install additional useful tools
RUN apt-get update && apt-get install -y \
    bash-completion \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# The zmk-dev-arm image has user 'ubuntu' with UID 1000
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=1000

# Give user sudo access
RUN echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set up bash completion for west
RUN echo 'eval "$(register-python-argcomplete west 2>/dev/null)"' >> /home/$USERNAME/.bashrc

# Create workspace directory and set ownership
RUN mkdir -p /workspaces/zmk-config /workspaces/zmk \
    && chown -R $USER_UID:$USER_GID /workspaces

# Set working directory
WORKDIR /workspaces/zmk-config

# Default user
USER $USERNAME


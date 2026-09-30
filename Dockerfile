FROM node:22-bookworm

# Pinned so a version bump busts the layer cache (unpinned, a cached layer
# silently keeps an old CLI that rejects newer model ids).
ARG CLAUDE_CODE_VERSION=2.1.285
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}

# Claude CLI refuses --dangerously-skip-permissions when running as root/sudo,
# and this proxy always passes that flag - so the container must run as a
# regular user, not root.
RUN useradd -m -s /bin/bash claudeuser

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

RUN chown -R claudeuser:claudeuser /app

USER claudeuser

EXPOSE 3456

CMD ["npm", "start"]

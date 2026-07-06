# ==========================================
# Git - Advanced Git and GitHub Functions
# ==========================================

function git-create
    if test -z "$argv[1]"
        echo "❗ Please provide a repository name."
        return 1
    end
    if not test -d .git
        echo "📦 Initializing Git repository..."
        git init
    end
    gh repo create "$argv[1]" --public --source=. --remote=origin
end

function git-create-private
    if test -z "$argv[1]"
        echo "❗ Please provide a repository name."
        return 1
    end
    if not test -d .git
        echo "📦 Initializing Git repository..."
        git init
    end
    echo "🔒 Creating PRIVATE GitHub repo: $argv[1]"
    gh repo create "$argv[1]" --private --source=. --remote=origin
end

function git-update
    if test -z "$argv[1]"
        echo "❗ Please provide a commit message."
        return 1
    end
    git add .
    git commit -m "$argv[1]"
    git push
end

function git-delete-branch
    git branch -d $argv[1]
    and git push origin --delete $argv[1]
end

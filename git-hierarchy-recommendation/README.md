Here's a step-by-step guide for creating a new project with Git, including creating two branches (main and nonprod):
===
It will be abstract info, but I don't know that write me here. If you have an idea, please to make pull request!

## Paper Information
- Title: Default project
- Author: Someone else

##  Tips for create default project
- Create a new directory for your project (your name instead of project-name):
  ```
  mkdir project-name
  ```
- Navigate into the new directory:
  ```
  cd project-name
  ```
- Initialize Git in the directory:
  ```
  git init
  ```
- Create the main branch (which will serve as the default branch):
  ```
  git checkout -b main
  ```
- Create the nonprod branch:
  ```
  git branch nonprod
  ```
- Switch back to the main branch:
  ```
  git checkout main
  ```
- Create a new file called README.md:
  ```
  touch README.md
  ```
- Open the README.md file in your preferred text editor (like VIM, NANO, VSCode and etc) and add a brief description of the project and any instructions for getting started. Usually, we have title and short definitions about project.
- Add the README.md file to Git:
  ```
  git add README.md
  ```
- Commit the changes:
  ```
  git commit -m "Initial commit with README.md"
  ```
- Add the remote repository to your local Git repository, also your link name (like an alias) maybe used instead of origin:
  ```
  git remote add origin <repository-url>
  ```
- Verify that the remote repository was added successfully:
  ```
  git remote -v
  ```
- Push the changes to the main branch:
  ```
  git push -u origin main
  ```
- Push the nonprod branch to the remote repository:
  ```
  git push -u origin nonprod
  ```

## A little bit about best practices for README.md files

- Use clear, concise language to describe your project and its purpose.
- Include any necessary setup instructions or prerequisites for getting started with the project.
- Use headings and bullet points to organize information and make it easier to read.
- Include any relevant links or resources, such as documentation, tutorials, or other projects.
- Use tags or badges to indicate the status of the project (e.g. "in development", "stable", "deprecated", etc.).
- Keep the README.md file up-to-date as the project evolves and changes.
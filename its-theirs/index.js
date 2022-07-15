const fs = require("fs");
// require("dotenv").config();
const octokit = require("@octokit/core");
const repo = core.getInput('repo', { required: true });
const token = core.getInput('token', { required: true });

const client = new octokit.Octokit({ auth: token });

async function updateAllRepos() {

	try {
		const res = await client.request("GET /user/repos", {
			sort: "updated",
			per_page: "100",
		});
		const repos = res.data.filter(r => r.name !== "nostradini" && r.name !== "projects-readme" && r.name !== "projects-readme-tutorial");
		for (let i = 0; i < repos.length; i++) {
			const { name } = repos[i];
			updateReadMe(name);
		}
	} catch (error) {
		console.log(error);
	}
}

async function updateReadMe(repo) {
	try {
		const res = await client.request(`GET /repos/nostradini/${repo}/contents/README.md`);
		const { path, sha, content, encoding } = res.data;
		const rawContent = Buffer.from(content, encoding).toString();
		const startIndex = rawContent.indexOf("## Other Projects");
		const updatedContent = `${startIndex === -1 ? rawContent : rawContent.slice(0, startIndex)}\n${getNewProjectSection()}`;
		commitNewReadme(repo, path, sha, encoding, updatedContent);
	} catch (error) {
		try {
			const content = `\n${getNewProjectSection()}`;
			await client.request(`PUT /repos/geraldiner/${repo}/contents/README.md`, {
				message: "Create README",
				content: Buffer.from(content, "utf-8").toString(encoding),
			});
		} catch (err) {
			console.log(err);
		}
	}
}

async function commitNewReadme(repo, path, sha, encoding, updatedContent) {
	try {
		await client.request(`PUT /repos/nostadini/${repo}/contents/{path}`, {
			message: "Update README",
			content: Buffer.from(updatedContent, "utf-8").toString(encoding),
			path,
			sha,
		});
	} catch (err) {
		console.log(err);
	}
}

function getNewProjectSection() {
	return fs.readFileSync("projects.md").toString();
}

updateAllRepos();





// content: Base64.encode(
//     `${frontmatter(article)}\n\n${article.markdown}`
// ),

// async function getSHA(path) {
//     const result = await octokit.repos.getContent({
//       owner: "nostradini",
//       repo: "myrepo4",
//       path,
//     });
//       const sha = result?.data?.sha;
//       return sha;
//   }

//   async function commitArticle(article) {
//     const path = `${slug(article.title)}.md`;
//     const sha = await getSHA(path);
  
//     const result = await octokit.repos.createOrUpdateFileContents({
//       owner: "owner",
//       repo: "repo",
//       path,
//       message: `Add article "${article.title}"`,
//       content: Base64.encode(`${frontmatter(article)}\n\n${article.markdown}`),
//       sha,
//     });
  
//     return result?.status || 500;
//   }

  
//   const main = async () => {
//     const core = require('@actions/core');
//     const github = require('@actions/github');

//     const owner = core.getInput('commit_user_name', { required: true });
//     const repo = core.getInput('repo', { required: true });
//     const pr_number = core.getInput('pr_number', { required: true });
//     const token = core.getInput('token', { required: true });

//     const octokit = new github.getOctokit(token);

//     const { data: changedFiles } = await octokit.rest.pulls.listFiles({
//         owner,
//         repo,
//         pull_number: pr_number,
//       });

//       let diffData = {
//         additions: 0,
//         deletions: 0,
//         changes: 0
//       };

//       diffData = changedFiles.reduce((acc, file) => {
//         acc.additions += file.additions;
//         acc.deletions += file.deletions;
//         acc.changes += file.changes;
//         return acc;
//       }, diffData);

//     // commitArticle(CHANGELOG);
//   }

//   main()
    

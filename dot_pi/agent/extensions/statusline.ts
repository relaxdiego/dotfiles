/**
 * Custom footer that mirrors my Claude Code status line
 * (see ~/.claude/statusline.sh). Segments, from left to right:
 *   model  ctx%  $cost  branch  path
 * Colors use the same muted 256-color palette as the shell version,
 * emitted as raw ANSI so they match regardless of the pi theme.
 */

import type { AssistantMessage } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth } from "@earendil-works/pi-tui";
import { homedir } from "node:os";

// Muted 256-color palette, same codes as statusline.sh.
const R = "\x1b[0m";
const C_MODEL = "\x1b[38;5;110m"; // soft blue
const C_CTX = "\x1b[38;5;144m"; // soft khaki
const C_COST = "\x1b[38;5;180m"; // soft tan
const C_BRANCH = "\x1b[38;5;108m"; // soft green
const C_PATH = "\x1b[38;5;245m"; // gray

export default function (pi: ExtensionAPI) {
	pi.on("session_start", (_event, ctx) => {
		ctx.ui.setFooter((tui, _theme, footerData) => {
			const unsub = footerData.onBranchChange(() => tui.requestRender());

			return {
				dispose: unsub,
				invalidate() {},
				render(width: number): string[] {
					// Model display name (falls back to id).
					const model = ctx.model?.name ?? ctx.model?.id ?? "no-model";

					// Context window usage percentage.
					const usage = ctx.getContextUsage();
					const ctxPct = Math.floor(usage?.percent ?? 0);

					// Estimated session cost: sum of assistant usage.
					let cost = 0;
					for (const e of ctx.sessionManager.getBranch()) {
						if (e.type === "message" && e.message.role === "assistant") {
							cost += (e.message as AssistantMessage).usage.cost.total;
						}
					}

					// Current working directory, with $HOME shown as ~.
					const home = homedir();
					const dir = ctx.cwd;
					const path = dir.startsWith(home) ? `~${dir.slice(home.length)}` : dir;

					const branch = footerData.getGitBranch();

					let line = `${C_MODEL}${model}${R}  ${C_CTX}${ctxPct}% ctx${R}`;
					line += `  ${C_COST}$${cost.toFixed(2)}${R}`;
					if (branch) line += `  ${C_BRANCH}⎇ ${branch}${R}`;
					line += `  ${C_PATH}${path}${R}`;

					return [truncateToWidth(line, width)];
				},
			};
		});
	});
}

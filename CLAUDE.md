
## Cockpit activity log (ACTIVITY.md)

Aiman's VIFM Cockpit (cockpit.viftraining.com) opens a new Claude Code session on this repository for each email about this product, with the request already typed. Sessions come and go, so `ACTIVITY.md` at the root of this repository is the single running record of how this product is moving.

In every session that starts from the cockpit (and in any session that changes what this product does):
1. Read `ACTIVITY.md` first to pick up the latest decisions and open items.
2. When the item is handled, add an entry at the TOP of `ACTIVITY.md`: date, the email (subject and sender), Aiman's decision, what changed (branch, PR or commit), and anything still pending. Commit that entry straight to the default branch with a message starting `activity:`.
3. Add the Outlook category "Done" to the email and any copy of it, if this session has the Microsoft 365 connector, so it leaves the cockpit. If it does not, say so and Aiman will tick it off on the cockpit.

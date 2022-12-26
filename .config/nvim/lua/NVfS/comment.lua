local cmp_status_ok, comment = pcall(require, "Comment")
if not cmp_status_ok then
	return
end

comment.setup()

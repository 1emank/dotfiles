if os.execute('[ -d ~/repos/nvim/tog ]') == 0 then
    return {
        dir = '~/repos/nvim/tog',
        opts = {}
    }
else
    return {}
end

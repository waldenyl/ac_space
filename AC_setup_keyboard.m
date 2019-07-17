function k = AC_setup_keyboard(ini)

KbName('UnifyKeyNames');
k.escape = KbName('ESCAPE');
k.space = KbName('space');
k.need_restrict = [KbName(ini.target_key(1)), KbName(ini.target_key(2) ...
    ), KbName(ini.target_key(3)), KbName(ini.target_key(4)), k.escape, ...
    k.space, KbName('c')];

end
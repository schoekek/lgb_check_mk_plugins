#!/usr/bin/python
# -*- encoding: utf-8; py-indent-offset: 4 -*-

import lgb_visibility_control

pagehandlers.update({
    "switch_user_visibility"       : lgb_visibility_control.ajax_switch_visibility_control,
})

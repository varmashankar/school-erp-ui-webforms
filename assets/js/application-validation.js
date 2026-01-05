(function (global) {
    'use strict';

    function byId(id) {
        return global.document.getElementById(id);
    }

    function setError(field, errorId, on) {
        if (!field) return;
        if (on) field.classList.add('error');
        else field.classList.remove('error');

        var err = errorId ? byId(errorId) : null;
        if (err) {
            if (on) err.classList.add('show');
            else err.classList.remove('show');
        }
    }

    function validateField(el, errorKeyOrId) {
        if (!el) return true;

        var value = (el.value || '').trim();
        var ok = value.length > 0;

        var errorId = errorKeyOrId;
        // Convention used in pages: pass key like 'parentName' -> element id 'parentNameError'
        if (errorKeyOrId && errorKeyOrId.indexOf('Error') === -1)
            errorId = errorKeyOrId + 'Error';

        setError(el, errorId, !ok);
        return ok;
    }

    function validateMobile(el, errorId) {
        if (!el) return true;
        var value = (el.value || '').trim();
        var ok = /^[0-9]{10}$/.test(value);
        setError(el, errorId || 'mobileError', !ok);
        return ok;
    }

    function validateEmail(el, errorId) {
        if (!el) return true;
        var value = (el.value || '').trim();
        // reasonable simple check (don’t overvalidate)
        var ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
        setError(el, errorId || 'emailError', !ok);
        return ok;
    }

    // Expose globally for inline oninput handlers
    global.validateField = global.validateField || validateField;
    global.validateMobile = global.validateMobile || validateMobile;
    global.validateEmail = global.validateEmail || validateEmail;

})(window);

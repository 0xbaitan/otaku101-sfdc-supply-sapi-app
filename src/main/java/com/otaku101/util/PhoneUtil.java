package com.otaku101.util;

import com.google.i18n.phonenumbers.NumberParseException;
import com.google.i18n.phonenumbers.PhoneNumberUtil;
import com.google.i18n.phonenumbers.Phonenumber.PhoneNumber;

public class PhoneUtil {
	public static boolean isValidE164(String phone) {

		PhoneNumberUtil lib = PhoneNumberUtil.getInstance();

		if (phone == null || !phone.matches("^\\+[1-9]\\d{1,14}$")) {
			return false;
		}

		try {
			PhoneNumber parsedNumber = lib.parse(phone, "ZZ");
			return lib.isValidNumber(parsedNumber);

		} catch (NumberParseException e) {
			return false;
		}
	}
}

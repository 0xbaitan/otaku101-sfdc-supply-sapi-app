package com.otaku101.util;

import com.fasterxml.uuid.Generators;
import com.fasterxml.uuid.impl.TimeBasedEpochGenerator;

public class IdGenerator {
	private static final TimeBasedEpochGenerator gen = Generators.timeBasedEpochGenerator();
	public static String generateUUID7() {
		return gen.generate().toString();
	}

}

import processing.pdf.*;
import java.util.Random;
import java.util.Collections;
import java.util.Arrays;
import java.util.Map;
import java.util.HashMap;

import com.google.common.base.Objects;
import com.google.common.base.Joiner;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicBoolean;

SortingMachine m;
Drawable r;

void setup() {
	m = new SortingMachine("/Users/d/git/sortvis/config.json");
	r = m.getRenderer();
	r.setup();
}

List<Instruction> sort(Sorter sorter, int[] in) {
	int[] items = copy(in);
	List<Instruction> steps = sorter.plan(items);
	return steps;
}

void draw() {
	r.draw();
	r.tick();
}

int[] copy(int[] a) {
	int[] out = new int[a.length];
	System.arraycopy(a, 0, out, 0, a.length);
	return out;
}

public int[] asIntArray(Map<String, Object> m, String key) {
	List<Object> list = (List<Object>)m.get(key);
	int[] a = new int[list.size()];
	for(int i = 0; i < a.length; i++) {
		a[i] = (Integer)list.get(i);
	}
	return a;
}

public String[] asStringArray(Map<String, Object> m, String key) {
	List<Object> list = (List<Object>)m.get(key);
	String[] a = new String[list.size()];
	for(int i = 0; i < a.length; i++) {
		a[i] = (String)list.get(i);
	}
	return a;
}

public String join(int[] a, String s) {
	List<Integer> list = Lists.newArrayListWithCapacity(a.length);
	for(int i = 0; i < a.length; i++) {
		list.add(a[i]);
	}
	return Joiner.on(s).join(list);
}


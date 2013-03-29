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

Sorter bubblesort = new BubbleSorter();
Sorter quicksort = new QuickSorter();
int[] items = new int[100];

List<Instruction> bubbleSortPlan;
List<Instruction> quickSortPlan;

boolean simple = true;
final float lmargin = 10f, rmargin = 10f;
final float tmargin = 20f, bmargin = 10f;
final float stepWidth = 20f;
final float lineMargin = 20f;
final float lineHeight = items.length * 4 + lineMargin;

float cursorX = lmargin, cursorY = tmargin;
float offsetX;
SortingMachine m;
Drawable r;

int programCounter = -1;
Instruction instruction;

void setup() {

	m = new SortingMachine("/Users/d/git/sortvis/config.json");
	r = m.getRenderer();
	r.setup();

	offsetX = width;

	List<Integer> list = new ArrayList<Integer>(items.length);
	for(int i = 0; i < items.length; i++) {
		list.add(items.length-i);
	}
	Collections.shuffle(list);
	for(int i = 0; i < items.length; i++) {
		items[i] = list.get(i);
	}

	bubbleSortPlan = sort(bubblesort, items);
	quickSortPlan = sort(quicksort, items);
}

List<Instruction> sort(Sorter sorter, int[] in) {
	int[] items = copy(in);
	List<Instruction> steps = sorter.plan(items);
	return steps;
}

int[] copy(int[] a) {
	int[] out = new int[a.length];
	System.arraycopy(a, 0, out, 0, a.length);
	return out;
}

void draw() {
	r.draw();
	r.tick();
	/**
	background(255,255,255);
	resetCursor();
	if(simple) {
		offsetX = 0;
		//drawPlan(items, bubbleSortPlan);
		//newline();
		drawPlan(items, quickSortPlan);
	}
	else {
		drawPlan(items, quickSortPlan);
		offsetX -= 4;
		renderItems();
	}
	**/
}
/**
void emitInstruction(Instruction i) {
	instruction = i;
	instruction.exec(items);
}

void renderItems() {
	pushMatrix();
	pushStyle();
	translate(lmargin,tmargin+lineHeight+tmargin);
	noStroke();
	fill(0,0,0,50);
	float itemPixels = width-lmargin-rmargin;
	float itemWidth = itemPixels/(float)items.length;
	for(int i = 0; i < items.length; i++) {
		float x = i*itemWidth;
		pushStyle();
		if(instruction != null) {
			if(i == instruction.hi() || i == instruction.lo()) {
				if(instruction.swap()) {
					fill(0,0,0,255);
				}
				else {
					fill(255,0,0,200);
				}
			}
			else if(instruction.isControlPoint(i)) {
				fill(15,59,160,100);
			}
		}
		rect(x, items.length - items[i], itemWidth, items[i]);
		popStyle();
	}
	popStyle();
	popMatrix();
}

void drawPlan(int[] items, List<Instruction> plan) {
	int[] workingSet = copy(items);
	for(int i = 0; i < plan.size(); i++) {
		Instruction inst = plan.get(i);
		drawStep(workingSet, i, inst);
		incrementCursorPosition();
	}

	// clear instruction
	if(offsetX-width/2 < -1*plan.size()*stepWidth) {
		instruction = null;
	}
}

void drawStep(int[] workingSet, int pc, Instruction inst) {

	if(offsetX + cursorX + stepWidth < 0) {
		return;
	}
	if(offsetX + cursorX > width) {
		return;
	}

	pushMatrix();
	translate(offsetX + cursorX, cursorY);

	float linePixels = lineHeight - lineMargin;
	float itemHeight = linePixels / (float)workingSet.length;

	if(!simple && (offsetX + cursorX) < width/2 && (offsetX + cursorX + stepWidth) > width/2) {
		setProgramCounter(pc, inst);
		pushStyle();
		fill(255,255,0,50);
		noStroke();
		rect(0,0,stepWidth,linePixels);
		popStyle();
	}

	for(int i = 0; i < workingSet.length; i++) {
		float y = i * itemHeight;
		pushStyle();

		// draw control points no matter what
		if(inst.isControlPoint(i) && !((i == inst.hi() || i == inst.lo()) && inst.swap())) {
			stroke(15,59,160,100);
			line(0, y, stepWidth-1f, y);
		}

		if(i == inst.hi() || i == inst.lo()) {
			if(inst.swap()) {
				stroke(0,0,0,255);
			}
			else {
				stroke(255,0,0,200);
			}
		}
		else {
			stroke(0,0,0,30);
		}
		if(inst.swap()) {
		/**
		  noFill();
          beginShape();
          vertex(startX, drawY);
          bezierVertex(cx1, cy1, cx2, cy2, endX, thumbnailY);
          endShape();
		/
			if(i == inst.hi()) {
				float endY = inst.lo() * itemHeight;
				// curve to step.lo()
				noFill();
				beginShape();
				vertex(0, y);
				bezierVertex(stepWidth/2f, y, stepWidth - stepWidth/2f, endY, stepWidth, endY);
				endShape();
			}
			else if(i == inst.lo()) {
		
				// curve to step.hi()
				float endY = step.hi() * itemHeight;
				// curve to step.lo()
				noFill();
				beginShape();
				vertex(0, y);
				bezierVertex(stepWidth/2f, y, stepWidth - stepWidth/2f, endY, stepWidth, endY);
				endShape();
			**
			}
			else {
				line(0, y, stepWidth-1f, y);
			}
		}
		else {
			line(0, y, stepWidth-1f, y);
		}
		popStyle();
	}
	popMatrix();
}
**/
/**
void incrementCursorPosition() {
	cursorX += stepWidth;
	if(simple) {
		if(cursorX >= (width-stepWidth-rmargin)) {
			cursorX = lmargin;
			cursorY += lineHeight;
		}
	}
}

void resetCursor() {
	cursorX = lmargin;
	cursorY = tmargin;
}

void newline() {
	cursorX = lmargin;
	cursorY += lineHeight;
}

void setProgramCounter(int pc, Instruction i) {
	if(programCounter != pc) {
		programCounter = pc;
		emitInstruction(i);
	}
}
**/

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


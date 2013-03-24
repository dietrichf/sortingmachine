import java.util.Random;
import java.util.Collections;
import java.util.Arrays;
import java.util.Map;

import com.google.common.base.Objects;

import com.fasterxml.jackson.databind.ObjectMapper;

Sorter bubblesort = new BubbleSorter();
Sorter quicksort = new QuickSorter();
int[] items = new int[100];

List<Step> bubbleSortPlan;
List<Step> quickSortPlan;

final float lmargin = 10f, rmargin = 10f;
final float tmargin = 20f, bmargin = 10f;
final float stepWidth = 20f;
final float lineMargin = 20f;
final float lineHeight = items.length * 4 + lineMargin;

float cursorX = lmargin, cursorY = tmargin;
float offsetX;
SortingMachine m;
IRenderer r;
boolean simple = false;

int programCounter = -1;
Step instruction;

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

List<Step> sort(Sorter sorter, int[] in) {
	int[] items = copy(in);
	List<Step> steps = sorter.plan(items);
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
}

void emitStep(Step step) {
	instruction = step;
	step.exec(items);
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

void drawPlan(int[] items, List<Step> plan) {
	int[] workingSet = copy(items);
	for(int i = 0; i < plan.size(); i++) {
		Step step = plan.get(i);
		drawStep(workingSet, i, step);
		incrementCursorPosition();
	}

	// clear instruction
	if(offsetX-width/2 < -1*plan.size()*stepWidth) {
		instruction = null;
	}
}

void drawStep(int[] workingSet, int pc, Step step) {

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
		setProgramCounter(pc, step);
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
		if(step.isControlPoint(i) && !((i == step.hi() || i == step.lo()) && step.swap())) {
			stroke(15,59,160,100);
			line(0, y, stepWidth-1f, y);
		}

		if(i == step.hi() || i == step.lo()) {
			if(step.swap()) {
				stroke(0,0,0,255);
			}
			else {
				stroke(255,0,0,200);
			}
		}
		else {
			stroke(0,0,0,30);
		}
		if(step.swap()) {
		/**
		  noFill();
          beginShape();
          vertex(startX, drawY);
          bezierVertex(cx1, cy1, cx2, cy2, endX, thumbnailY);
          endShape();
		**/
			if(i == step.hi()) {
				float endY = step.lo() * itemHeight;
				// curve to step.lo()
				noFill();
				beginShape();
				vertex(0, y);
				bezierVertex(stepWidth/2f, y, stepWidth - stepWidth/2f, endY, stepWidth, endY);
				endShape();
			}
			else if(i == step.lo()) {
			/**
				// curve to step.hi()
				float endY = step.hi() * itemHeight;
				// curve to step.lo()
				noFill();
				beginShape();
				vertex(0, y);
				bezierVertex(stepWidth/2f, y, stepWidth - stepWidth/2f, endY, stepWidth, endY);
				endShape();
			**/
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

void setProgramCounter(int pc, Step step) {
	if(programCounter != pc) {
		programCounter = pc;
		emitStep(step);
	}
}

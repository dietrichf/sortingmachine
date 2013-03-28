class Renderer implements IRenderer {
	
	SortingMachine m;
	float cursorX, cursorY = 0f;
	float offsetX = 0f;

	float stepWidth = 20f;
	float labelHeight = 20f;
	float lineMargin = 10f;
	float lineHeight;

	PFont labelFont = createFont("Georgia", 16);

	Renderer(SortingMachine m) {
		this.m = m;
	}

	public void setup() {
		System.out.println("configuring standard view");
		m.setup();
		stepWidth = m.getStepWidth();
	}

	public void tick() { }

	public void draw() {
		background(255, 255, 255);
		resetCursor();
		for(SortJob job : m.getSortJobs()) {
			DataSet data = job.getData();
			int[] a = data.getValues();
			lineHeight = a.length * m.getNoteHeight() + lineMargin;

			// put labelkj
			cursorY += 10f;
			pushStyle();
			fill(80);
			textFont(labelFont);
			textAlign(LEFT, CENTER);
			text(job.getLabel(), m.getWindow().getLeftMargin(), cursorY);
			popStyle();
			cursorY += labelHeight;

			drawPlan(a, job.getInstructions());
			newline();
		}
	}

	void drawPlan(int[] items, List<Step> plan) {
		int[] workingSet = copy(items);
		for(int i = 0; i < plan.size(); i++) {
			Step step = plan.get(i);
			drawStep(workingSet, step);
			incrementCursorPosition();
		}
	}

	void drawStep(int[] workingSet, Step step) {

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
		if(cursorX >= (width-stepWidth-m.getWindow().getRightMargin())) {
			cursorX = m.getWindow().getLeftMargin();
			cursorY += lineHeight;
		}
	}

	void resetCursor() {
		cursorX = m.getWindow().getLeftMargin();
		cursorY = m.getWindow().getTopMargin();
	}

	void newline() {
		cursorX = m.getWindow().getLeftMargin();
		cursorY += lineHeight;
	}
}

class Renderer implements Drawable {
	
	SortingMachine m;

	// TODO - delete these guys
	float offsetX = 0f;
	float instWidth = 20f;

	float labelHeight = 20f;
	float lineMargin = 10f;
	float lineHeight;
	float cursorX, cursorY;
	
	PFont labelFont = createFont("Georgia", 16);

	private final List<Drawable> drawables;

	Renderer(SortingMachine m) {
		this.m = m;
		drawables = new ArrayList<Drawable>();
	}

	public void setup() {
		System.out.println("configuring standard view");
		m.setup();
		float noteHeight = m.getNoteHeight();
		float noteWidth = m.getStepWidth();
		cursorX = m.getWindow().getLeftMargin();
		cursorY = m.getWindow().getTopMargin();
		for(SortJob job : m.getSortJobs()) {
			LabelDrawable lbl =
				new LabelDrawable(
					job.getLabel(), cursorX, cursorY, LEFT, CENTER,
					labelFont
				);
			drawables.add(lbl);
			cursorY += labelHeight;
			DataSet data = job.getData();
			int[] a = data.getValues();
			lineHeight = a.length * m.getNoteHeight() + lineMargin;
			for(Instruction instruction : job.getInstructions()) {
				InstructionDrawable d =
					new InstructionDrawable(
						instruction,
						cursorX, cursorY,
						noteHeight, noteWidth, 
						a
					);
				drawables.add(d);
				incrementCursorPosition(noteWidth);
			}
			newline();
		}
	}

	void incrementCursorPosition(float amt) {
		cursorX += amt;
		if(cursorX >= (width-amt-m.getWindow().getRightMargin())) {
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

	public void tick() { }

	public void draw() {
		background(255, 255, 255);
		for(Drawable d : drawables) {
			d.draw();
		}
		/**
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
		**/
	}

	void drawPlan(int[] items, List<Instruction> plan) {
		int[] workingSet = copy(items);
		for(int i = 0; i < plan.size(); i++) {
			Instruction inst = plan.get(i);
			drawStep(workingSet, inst);
			incrementCursorPosition(10f);
		}
	}

	void drawStep(int[] workingSet, Instruction inst) {

		if(offsetX + cursorX + instWidth < 0) {
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
			if(inst.isControlPoint(i) && !((i == inst.hi() || i == inst.lo()) && inst.swap())) {
				stroke(15,59,160,100);
				line(0, y, instWidth-1f, y);
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
			**/
				if(i == inst.hi()) {
					float endY = inst.lo() * itemHeight;
					// curve to inst.lo()
					noFill();
					beginShape();
					vertex(0, y);
					bezierVertex(instWidth/2f, y, instWidth - instWidth/2f, endY, instWidth, endY);
					endShape();
				}
				else if(i == inst.lo()) {
				/**
					// curve to inst.hi()
					float endY = inst.hi() * itemHeight;
					// curve to inst.lo()
					noFill();
					beginShape();
					vertex(0, y);
					bezierVertex(instWidth/2f, y, instWidth - instWidth/2f, endY, instWidth, endY);
					endShape();
				**/
				}
				else {
					line(0, y, instWidth-1f, y);
				}
			}
			else {
				line(0, y, instWidth-1f, y);
			}
			popStyle();
		}
		popMatrix();
	}
}

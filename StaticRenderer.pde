class StaticRenderer implements Drawable { 
	SortingMachine m;

	float labelHeight = 20f;
	float lineMargin = 10f;
	float lineHeight;
	float cursorX, cursorY;
	
	PFont labelFont = createFont("Georgia", 16);

	private final List<Drawable> drawables;

	StaticRenderer(SortingMachine m) {
		this.m = m;
		drawables = new ArrayList<Drawable>();
	}

	public void place(Point p) { }

	public float getWidth() {
		return width;
	}

	public float getHeight() {
		return height;
	}

	public void setup() {
		System.out.println("configuring standard view");
		m.setup();
		size(
			m.getWindow().getWidth(),
			m.getWindow().getHeight());
		background(255);
		noLoop();
		beginRecord(PDF, "out.pdf");
		float noteHeight = m.getNoteHeight();
		float noteWidth = m.getStepWidth();
		cursorX = m.getWindow().getLeftMargin();
		cursorY = m.getWindow().getTopMargin();
		for(SortJob job : m.getSortJobs()) {
			LabelDrawable lbl =
				new LabelDrawable(
					job.getLabel(), LEFT, CENTER,
					labelFont
				);
			lbl.place(new Point(cursorX, cursorY));
			drawables.add(lbl);
			cursorY += labelHeight;
			DataSet data = job.getData();
			int[] a = data.getValues();
			lineHeight = a.length * m.getNoteHeight() + lineMargin;
			for(Instruction instruction : job.getInstructions()) {
				InstructionDrawable d =
					new InstructionDrawable(
						instruction,
						noteHeight, noteWidth, 
						a
					);
				d.place(new Point(cursorX, cursorY));
				drawables.add(d);
				incrementCursorPosition(noteWidth);
			}
			newline();
			cursorY += 10f;
		}
	}

	void incrementCursorPosition(float amt) {
		cursorX += amt;
		if(cursorX >= (width-amt-m.getWindow().getRightMargin())) {
			newline();
		}
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
		endRecord();
	}
}

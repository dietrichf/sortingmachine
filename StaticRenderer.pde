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
	}
}

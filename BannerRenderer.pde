class BannerRenderer implements Drawable {

	private SortingMachine m;
	private final List<Drawable> drawables;

	BannerRenderer(SortingMachine m) {
		this.m = m;
		drawables = new ArrayList<Drawable>();
	}

	public void setup() {
		println("configuring banner");
		background(255);

		float noteHeight = m.getNoteHeight();
		float noteWidth = m.getStepWidth();
		SortJob job = m.getSortJobs().get(0);
		List<Instruction> program = job.getInstructions();
		DataSet data = job.getData();

		// get a sorted set of ints
		int[] sorted = data.getValues();
		Arrays.sort(sorted);

		int[] snapshot = data.getValues();

		int positiveColor = color(0, 0, 0, 40);
		int negativeColor = color(0, 76, 192, 180);
		int snapshotColor = color(255, 74, 0, 100);

		float chartWidth = 50;
		float chartHeight = 30;

		size(
			(int)(m.getWindow().getLeftMargin() + m.getWindow().getRightMargin() + program.size() * noteWidth),
			(int)(m.getWindow().getTopMargin() + m.getWindow().getBottomMargin() + (snapshot.length * noteHeight) * 3 + chartHeight * 25)
		);

		Layout layout =
			new Layout(
				m.getWindow().getLeftMargin(), m.getWindow().getTopMargin(),
				width - m.getWindow().getRightMargin(), height);

		List<Drawable> histos = new ArrayList<Drawable>();

		ArrayDrawable first =
			new ArrayDrawable(
				snapshot, chartWidth, chartHeight, 4, 4, 3, 3, snapshotColor
			);
		first.setup();
		histos.add(first);

		for(Instruction instruction : program) {
			if(histos.isEmpty()) {
				ArrayDrawable d =
					new ArrayDrawable(
						snapshot, chartWidth, chartHeight, 4, 4, 3, 3, snapshotColor
					);
				d.setup();
				histos.add(d);
			}
			instruction.exec(snapshot);
			if(instruction.swap() || histos.isEmpty()) {
				ArrayDrawable d =
					new ArrayDrawable(
						snapshot, chartWidth, chartHeight, 4, 4, 3, 3, snapshotColor
					);
				d.setup();
				histos.add(d);
			}
		}

		downsampleOneRow(layout, histos, drawables);

		snapshot = data.getValues();
		// after each instruction, determine which elements are in their final spot
		for(Instruction instruction : program) {
			instruction.exec(snapshot);
			Drawable d =
				new BannerDrawable(
					noteWidth, noteHeight, snapshot, sorted,
					positiveColor, negativeColor, 1f, 1f
				);
			drawables.add(d);
			layout.place(d);
		}

		snapshot = data.getValues();
		for(Instruction instruction : program) {
			instruction.exec(snapshot);
			Drawable d =
				new BannerDrawable(
					noteWidth, noteHeight, snapshot, sorted,
					negativeColor, positiveColor, 1f, 1f
				);
			drawables.add(d);
			layout.place(d);
		}

		for(Instruction instruction : program) {
			Drawable d =
				new InstructionDrawable(
					instruction,
					noteHeight, noteWidth, snapshot
				);
			d.setup();
			drawables.add(d);
			layout.place(d);
		}

		m.setup();
		noLoop();
		beginRecord(PDF, "banner.pdf");
	}

	void layoutAll(Layout layout, List<Drawable> in, List<Drawable> out) {
		for(Drawable d : in) {
			out.add(d);
			layout.place(d);

		}
	}

	void downsampleOneRow(Layout layout, List<Drawable> allDrawables, List<Drawable> sampleOutput) {
		// figure out how many histos we have room to display and sample
		float availWidth = layout.w-layout.left;
		float numSnapshots = availWidth / allDrawables.get(0).getWidth() - 1f;
		float sampling = (float)allDrawables.size() / numSnapshots;
		println("can fit " + numSnapshots + " snapshots but " + allDrawables.size() + " are available");
		println("sampling rate " + sampling);
		for(int i = 0; i < numSnapshots; i++) {
			int index = Math.round(sampling * (float)i);
			if(index >= allDrawables.size()-1) {
				break;
			}
			println("adding snapshot #" + index);
			Drawable d = allDrawables.get(index);
			sampleOutput.add(d);
			layout.place(d);
		}

		// add the last one
		Drawable lastSnapshot = allDrawables.get(allDrawables.size()-1);
		drawables.add(lastSnapshot);
		layout.place(lastSnapshot);

	}
	public void tick() {
	}

	public void draw() {
		for(Drawable d : drawables) {
			d.draw();
		}
		endRecord();
	}

	public void place(Point p) {}

	public float getWidth() {
		return width;
	}

	public float getHeight() {
		return height;
	}
}

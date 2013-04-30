class AnimatedRenderer implements Drawable {
	
	private SortingMachine m;

	private int pc = -1;

	private List<InstructionDrawable> instructionDrawables;
	private ArrayDrawable arrayDrawable;
	private List<ArrayDrawable> snapshots;
	private List<Instruction> program;

	Layout sheetLayout;

	private AtomicBoolean sendInstruction = new AtomicBoolean(false);

	AnimatedRenderer(SortingMachine m) {
		this.m = m;
		new ScheduledThreadPoolExecutor(1).scheduleAtFixedRate(
			new Runnable() {
				public void run() {
					sendInstruction.set(true);
				}
			}, 500L, 500L, TimeUnit.MILLISECONDS);
	}
	
	public void setup() {
		System.out.println("configuring standard view");
		m.setup();
		size(m.getWindow().getWidth(), m.getWindow().getHeight());
		sheetLayout = new Layout(m.getWindow().getLeftMargin(), m.getWindow().getTopMargin(), width/2, height);
		float cursorX = 0f, cursorY = 0f;
		SortJob job = m.getSortJobs().get(0);
		DataSet data = job.getData();
		program = job.getInstructions();
		layoutSheetMusic(data.getValues());
		arrayDrawable =
			new ArrayDrawable(
				data.getValues(), // values
				width/2f, 130,
				10, 10, 10, 10, color(0, 0, 0, 30)
			);
		arrayDrawable.place(
			new Point(
				width/2f, // x
				m.getWindow().getTopMargin() // y
			));
		arrayDrawable.setup();
		takeSnapshot();

// throwaway debug thing that makes sure that the sorting instructions work
		int[] a = copy(data.getValues());
		println("before -->\n" + join(a, ", ") + "\n");
		for(Instruction i : program) {
			i.exec(a);
		}
		println("after -->\n" + join(a, ", ") + "\n");
	}

  public void layoutSheetMusic(int[] a) {
		instructionDrawables = Lists.newArrayListWithCapacity(program.size());
		for(Instruction instruction : program) {
			InstructionDrawable d =
				new InstructionDrawable(
					instruction,
					m.getNoteHeight(), m.getStepWidth(),
					a
				);
			d.setup();
			instructionDrawables.add(d);
			sheetLayout.place(d);
		}
	}

	private void takeSnapshot() {
		if(snapshots == null) {
			snapshots = Lists.newArrayList();
		}
		ArrayDrawable s = arrayDrawable.clone();
		s.setup();
		s.setColor(0, 0, 0, 0);
		snapshots.add(s);
	}

	public void tick() {
		if(sendInstruction.get()) {
			nextInstruction();
			sendInstruction.set(false);
		}
		for(int i = 0; i < instructionDrawables.size(); i++) {
			InstructionDrawable d = instructionDrawables.get(i);
			d.tick();
			// set 'executing' flag if necessary
			d.setExecuting(i == pc);
		}
		arrayDrawable.tick();
		layoutSnapshots();
		for(Drawable s : snapshots) {
			s.tick();
		}
	}

	public void draw() {
		background(255,255,255);
		for(int i = 0; i < instructionDrawables.size(); i++) {
			Drawable d = instructionDrawables.get(i);
			d.draw();
		}
		arrayDrawable.draw();
		for(ArrayDrawable s : snapshots) {
			s.draw();
		}
		/*saveFrame("/tmp/sorting-machine/b-####.tif");*/
	}

	private void nextInstruction() {
		pc++;
		if(pc > program.size() - 1) {
			pc = program.size() - 1;
			//noLoop();
			return;
		}

		Instruction i = program.get(pc);
		arrayDrawable.execute(i);

		// record the state of the array after the swap
		if(i.swap()) {
			takeSnapshot();
		}
	}

	private void layoutSnapshots() {
		Layout snapshotLayout =
			new Layout(
					width/2f,
					arrayDrawable.x.value + arrayDrawable.getHeight(),
					width,
					0f
				);
		float visibleWidth = width/2f - m.getWindow().getLeftMargin() - m.getWindow().getRightMargin();
		float sx = width/2f;
		float sy = arrayDrawable.y.target + arrayDrawable.dheight.target;
		float swidth = visibleWidth/7f;
		float sheight = swidth * 7f / 16f;
		for(ArrayDrawable d : snapshots) {
			d.reposition(sx, sy, swidth, sheight, 8f, 8f, 8f, 8f);
			d.targetColor(0, 0, 0, 100);
			sx += swidth;
			if((sx+swidth) > (width-m.getWindow().getRightMargin())) {
				sx = width/2f;
				sy += sheight;
			}
		}
	}

	public void place(Point p) { }

	public float getWidth() {
		return width;
	}

	public float getHeight() {
		return height;
	}
}


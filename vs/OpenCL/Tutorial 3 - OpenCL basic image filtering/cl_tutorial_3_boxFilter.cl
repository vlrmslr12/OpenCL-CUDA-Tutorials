const sampler_t smp = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_LINEAR;

void kernel boxFilter(__read_only image2d_t in, __write_only image2d_t out, const int imageWidth, const int imageHeight, const int halfBoxWidth, const int halfBoxHeight)
{
	int x = get_global_id(0);
	int y = get_global_id(1);
	int2 pos = (int2)(x, y);

	uint4 total = {0, 0, 0, 0};

	int count = ((2 * halfBoxHeight) + 1) * ((2 * halfBoxWidth) + 1);

	for(int i = -halfBoxWidth; i <= halfBoxWidth; i++)
	{
		for(int j = -halfBoxHeight; j <= halfBoxHeight; j++)
		{
			int2 coord = pos + (int2)(i, j);
			if(coord.x < 0) coord.x += imageWidth;
			if(coord.x < 0) coord.y += imageWidth;
			total += read_imageui(in, smp, pos + (int2)(i, j));
		}
	}
	write_imageui(out, pos, total / count);
}
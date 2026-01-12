import { Controller, Post, Param, ParseIntPipe } from '@nestjs/common';
import { SpinsService } from './spins.service';

@Controller('spins')
export class SpinsController {
    constructor(private readonly spinsService: SpinsService) { }

    // POST /spins/1
    @Post(':userId')
    spin(@Param('userId', ParseIntPipe) userId: number) {
        return this.spinsService.spin(userId);
    }
}
